# == Schema Information
#
# Table name: products
#
#  sync_hash      :string(100)      not null, primary key
#  shop_id        :integer
#  sku            :string(100)
#  slug           :string
#  name           :string
#  description    :string(2000)
#  link           :string(512)
#  brand          :string(100)
#  keywords       :string(500)
#  currency       :string(3)
#  original_image :string(512)
#  image          :string
#  original_price :integer
#  price          :integer
#  gender         :string(20)
#  state          :integer          default("0")
#  created_at     :datetime
#  updated_at     :datetime
#  is_active      :boolean          default("true")
#  cached_tags    :text
#

class Product < ActiveRecord::Base
  extend FriendlyId
  include AASM
  include ActionView::Helpers::SanitizeHelper
  self.primary_key = 'sync_hash'

  mount_uploader :image, ImageUploader
  acts_as_taggable_on

  belongs_to :shop
  has_many :questions, -> { where('questions.state = ?', Question.states[:verified]) }

  enum state: {draft: 0, deleted: 1, verified: 2, identified: 3, published: 4}
  serialize :cached_tags, Hash
  validates_presence_of :sku, :name, :original_image, :link, :currency, :original_price, :price
  before_save :store_tags, on: :udate

  scope :newest, -> { order('products.updated_at DESC') }
  scope :active, -> { where(is_active: true) }
  scope :opened, -> { published.active.newest }
  scope :linen, -> { where(type: 'Linen') }
  scope :clothing, -> { where(type: 'Clothing') }

  friendly_id :slug_candidates, use: :slugged

  after_commit do
    if self.published?
      self.flush_cashed_context_tags
      Rails.cache.delete('product_last_records_10')
      IndexerWorker.perform_async(:index, self.id)
    end
  end

  def slug_candidates
    [self.name, self.shop.name, self.sku].join(' ')
  end

  def to_dom_id
    "#{self.class.name.tableize}_#{self.id}"
  end

  aasm column: :state, enum: true do
    state :draft, initial: true
    state :deleted
    state :verified
    state :identified
    state :published

    #обозначили как удаленное и мы его больше не показываем нигде
    event :hide do
      transitions to: :deleted,
                  after_transition: Proc.new { |obj, *args| IndexerWorker.perform_async(:delete, obj.id) if obj.aasm.from_state.eql?(:published) }
    end

    # подтвердили продукт как нормальный для показа и отправили в очерель для создания превью
    event :verify, after: Proc.new { create_thumb } do
      transitions from: [:deleted, :draft], to: :verified
    end

    # переход когда созданы превью для продукта
    event :identify do
      transitions from: [:verified, :draft], to: :identified
    end

    # после редактирования админом продукт становится доступный в публичной части
    event :publish do
      transitions from: :identified,
                  to: :published
      #on_transition: Proc.new { |obj, *args| IndexerWorker.perform_async(:index, obj.id) }
    end
  end

  def the_same_price?
    self.original_price.eql?(self.price)
  end

  def create_thumb
    ThumbWorker.perform_async(self.id)
  end

  def as_indexed_json(options={})
    self.as_json({only: [:id, :sku, :slug, :name, :description, :brand, :keywords, :price, :gender, :currency, :cached_tags, :is_active, :state],
                  include: {shop: {only: :name}},
                  methods: tag_types.collect { |type| "#{type}_list" }
                 })
  end

  def tags
    tags_hash = {}
    self.class.tag_types.each do |tags_type|
      tags = send("#{tags_type}_list".to_sym)
      tags_hash[tags_type] = tags unless tags.empty?
    end
    tags_hash
  end

  def store_tags
    self.cached_tags = tags
  end

  def related_products
    self.class.related_products(self).active.where.not(sync_hash: self.id).limit(4) rescue self.class.newest.limit(5)
  end

  def self.create_from_offer(shop_id, offer)
    product = find_or_initialize_by(sync_hash: Digest::SHA256.hexdigest("#{shop_id}-#{offer.id}")[0..35])
    if product.new_record?
      keywords = []
      keywords << offer.category.name
      keywords << offer.category.parent.name if offer.category.parent

      product.attributes = {
        shop_id: shop_id,
        sku: offer.id,
        name: offer.name || offer.model,
        description: sanitize(CGI::unescape_html(offer.description))[0..1999],
        link: offer.url,
        original_image: offer.picture,
        currency: offer.currency.id, #.name.encode('iso-8859-1').encode('utf-8'),
        price: offer.price,
        original_price: offer.price,
        brand: offer.vendor,
        keywords: keywords.join(', '),

      }
    #  product.send("#{model_name.singular}_category_list=", offer.category.name)
    else
      product.attributes = {
        price: offer.price,
        currency: offer.currency.id,
        is_active: offer.available
      }
    end

    unless product.save
      logger.error(product.errors.full_messages.inspect)
    end
    product
  end

  def self.create_thumb(id)
    product = find(id)
    product.remote_image_url = product.original_image
    product.save && product.identify! # : product.hide!
  end

  def self.last_records(limit = 10)
    Rails.cache.fetch("#{model_name.singular}_last_records_#{limit}", expires_in: 5.minutes) do
      self.opened.limit(limit).to_a
    end
  end

  def self.cashed_context_tags(context)
    #кешируем список контекстных тегов
    Rails.cache.fetch("#{model_name.singular}_cashed_tags_#{context}", expires_in: 5.minutes) do
      ActsAsTaggableOn::Tagging.where(context: context).joins(:tag).select('DISTINCT tags.name').map(&:name)
    end
  end

  def self.flush_cache
    Rails.cache.delete_matched(/^#{model_name.singular}/)
  end

  def cashed_context_tags(context)
    self.class.cashed_context_tags(context)
  end

  def flush_cashed_context_tags
    self.class.tag_types.each do |context|
      Rails.cache.delete("#{model_name.singular}_cashed_tags_#{context}")
    end
  end

  def tag_types
    self.class.tag_types
  end
end
