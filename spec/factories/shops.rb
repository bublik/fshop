# == Schema Information
#
# Table name: shops
#
#  id                            :integer          not null, primary key
#  name                          :string
#  shipping                      :text
#  affiliate_network_id          :string
#  affiliate_network_merchant_id :string
#  created_at                    :datetime
#  updated_at                    :datetime
#  logo                          :string
#  data_feeds_count              :integer          default("0")
#  target_url                    :string(500)
#  contact_email                 :string
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
