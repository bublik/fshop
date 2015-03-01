# == Schema Information
#
# Table name: shops
#
#  id                            :integer          not null, primary key
#  name                          :string(255)
#  shipping                      :text
#  affiliate_network_id          :string(255)
#  affiliate_network_merchant_id :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime
#  logo                          :string(255)
#  data_feeds_count              :integer          default(0)
#  target_url                    :string(500)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shop do
    sequence(:name) { |n| "#{n}-#{Faker::Company.name}" }
    target_url { Faker::Internet.url }
    shipping Faker::Lorem.paragraph
    affiliate_network_id { Faker::Code.isbn }
    affiliate_network_merchant_id { Faker::Code.ean }


    factory :shop_with_logo, class: Shop do
      logo Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/files/155x100.png')))
    end
  end

end
