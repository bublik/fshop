# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  product_id :text
#  username   :string
#  email      :string
#  message    :text
#  state      :integer          default("0")
#  parent_id  :integer
#  lft        :integer
#  rgt        :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    product
    username { Faker::Name.name }
    email { Faker::Internet.email }
    message { Faker::Lorem.sentences.join(' ') }

    trait :response do
      product nil
    end
  end
end
