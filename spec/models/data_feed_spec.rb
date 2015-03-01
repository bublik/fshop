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

require 'rails_helper'

RSpec.describe DataFeed, :type => :model do
  subject(:data_feed) { FactoryGirl.build(:data_feed) }

  describe 'Validates' do
    it { should be_valid }
    it { should belong_to(:shop) }
    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:url) }
    it { should allow_value('http://foo.com', 'http://bar.com/baz', 'https://comain.com/feed').for(:url) }
  end

end
