# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string
#  preview    :text
#  body       :text
#  slug       :string
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Blog, :type => :model do
  subject(:blog) { FactoryGirl.build(:blog) }

  describe 'Validates' do
    it { should be_valid }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:preview) }
    it { should validate_presence_of(:body) }
  end

  describe "Cashed content" do
    let!(:blog) { FactoryGirl.create(:blog) }
    before do
      Blog.flush_cache
    end

    it 'should return blog records' do
      expect(Blog.last_records).to eq([blog])
    end

    it 'should return 5 records' do
      10.times do
        FactoryGirl.create(:blog)
      end
      expect(Blog.last_records(5).count).to eq(5)
    end
  end

end
