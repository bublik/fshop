# == Schema Information
#
# Table name: products
#
#  sync_hash      :string(36)       not null, primary key
#  shop_id        :integer
#  sku            :string(100)
#  slug           :string(255)
#  name           :string(255)
#  description    :string(2000)
#  link           :string(512)
#  brand          :string(100)
#  keywords       :string(500)
#  currency       :string(3)
#  original_image :string(512)
#  image          :string(255)
#  original_price :integer
#  price          :integer
#  gender         :string(20)
#  state          :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  is_active      :boolean          default(TRUE)
#  cached_tags    :text
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    shop
    sync_hash { SecureRandom.urlsafe_base64 }
    sku { Faker::Code.ean }
    slug { Faker::Internet.slug }
    sequence(:name) { |n| "#{n}-#{Faker::Commerce.product_name}" }
    description { Faker::Lorem.sentences }
    link { Faker::Internet.url }
    brand { Faker::Company.name }
    keywords { Faker::Lorem.words.join(', ') }
    currency 'USD'
    original_image { Faker::Company.logo }
    original_price { Faker::Commerce.price }
    price { Faker::Commerce.price }
    gender "women"

    factory :verified_product, class: Product do
      state 4
    end
  end
end
