# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  preview    :text
#  body       :text
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :blog do
    sequence(:title) { |n| "#{Faker::Commerce.product_name}-#{n}" }
    preview { Faker::Lorem.sentences.join(' ') }
    body { Faker::Lorem.sentences(10).join(' ') }
  end
end
