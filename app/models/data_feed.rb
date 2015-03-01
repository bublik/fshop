# == Schema Information
#
# Table name: data_feeds
#
#  id         :integer          not null, primary key
#  shop_id    :integer
#  url        :string(255)
#  feed_type  :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

require 'uri'

class DataFeed < ActiveRecord::Base
  belongs_to :shop, counter_cache: true

  enum feed_type: {default: 0}

  validates_presence_of :url
  validates_uniqueness_of :url
  #validates_format_of :url, with: URI.regexp(['http', 'https'])
  validates_associated :shop
  validates_inclusion_of :feed_type, in: DataFeed.feed_types.keys

  def store_data
    # https://github.com/ArtemPyanykh/goods
    begin
      catalog = Goods.from_url(self.url, 'utf-8')

      # catalog.currencies.each do |currency|
      #   puts "Currency #{currency.id} #{currency.rate}" # => "RUR"
      #   # => 1.00 or 30.00 or some other float
      # end
      #
      # catalog.categories.each do |c|
      #   # category.id # => "some id"
      #   # category.name # => "some name"
      #   # category.parent # => <Goods::Category> or nil
      #   puts "Category #{c.id} #{c.name} #{c.parent}"
      # end

      catalog.offers.each do |offer|
        # puts offer.id # => "some id"
        #  c = offer.category  # => <Goods::Category>
        # puts "Category #{c.id} #{c.name} #{c.parent}"
        # puts offer.currency.rate # => <Goods::Currency>
        # puts offer.price # => 50.0 (for example)
        # puts offer.url
        # puts offer.picture
        # puts offer.description
        # puts offer.model
        # puts offer.vendor
        Product.create_from_offer(self.shop_id, offer)
      end


    rescue Goods::XML::InvalidFormatError => e
      puts e.message
    end
  end
end
