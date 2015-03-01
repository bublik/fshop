# == Schema Information
#
# Table name: coupons
#
#  id         :integer          not null, primary key
#  shop_id    :integer
#  name       :string(255)
#  code       :string(255)
#  start_date :datetime
#  end_date   :datetime
#  target_url :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    shop
    sequence(:name) { |n| "#{Faker::Commerce.product_name} $#{n}" }
    code { Faker::Code.ean }
    start_date "2014-07-24 07:37:28"
    end_date "2014-07-24 07:37:28"
    target_url { Faker::Internet.url }
  end
end
