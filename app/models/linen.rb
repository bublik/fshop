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
#  type           :string(15)
#

class Linen < Product
  acts_as_taggable_on :linen_category, :linen_size, :linen_occasion, :linen_length, :linen_colour, :linen_textile, :linen_item_type, :linen_style
  VISIBLE_TAGS = [:linen_category, :linen_size, :linen_occasion, :linen_length, :linen_colour, :linen_textile, :linen_item_type, :linen_style].freeze
  include Searchable

  def tag_types
    self.class.tag_types
  end

  def visible_tags
    Linen::VISIBLE_TAGS
  end
end
