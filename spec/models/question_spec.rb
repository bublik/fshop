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

require 'rails_helper'

RSpec.describe Question, :type => :model do
  subject(:question) { FactoryGirl.build(:question) }

  describe 'Validate' do
    it { should be_valid }

    it { should validate_presence_of(:product_id) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:message) }
  end

  describe 'New user question' do
    let(:question) { FactoryGirl.create(:question) }

    it 'should be pending question' do
      expect(question.pending?).to eq(true)
    end

    it 'should have product' do
      expect(question.product).not_to be_blank
    end
  end

  describe 'Admin Reponse' do
    let(:question) { FactoryGirl.create(:question) }
    let(:response){ FactoryGirl.build(:question, :response, parent: question) }

    it 'should not require product_id' do
      expect(response.valid?).to eq(true)
    end

    it 'should be child for client question'  do
      response.save
      expect(question.children).to include(response)
    end

    it 'should not as question for product' do
      expect(question.product.question_ids).not_to include(response.id)
    end
  end
end
