# == Schema Information
#
# Table name: data_feeds
#
#  id         :integer          not null, primary key
#  shop_id    :integer
#  url        :string
#  feed_type  :integer          default("0")
#  created_at :datetime
#  updated_at :datetime
#  sync_date  :datetime
#  category   :string           default("одежда"), not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_feed do
    shop
    url { Faker::Internet.url }
    feed_type DataFeed.feed_types.keys.first
  end
end
