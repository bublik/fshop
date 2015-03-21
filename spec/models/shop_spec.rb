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

require 'rails_helper'

RSpec.describe Shop, :type => :model do
  subject(:shop) { FactoryGirl.build(:shop) }

  describe 'Validate' do

    it { should be_valid }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:target_url) }
    it { should validate_presence_of(:shipping) }
    it { should validate_presence_of(:affiliate_network_id) }
    it { should validate_presence_of(:affiliate_network_merchant_id) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:affiliate_network_id) }
  end

  describe 'Create' do
    it 'should be persited record' do
      expect { shop.save }.to change { Shop.count }.by(1)
    end

    it 'should have logo' do
      shop = FactoryGirl.create(:shop_with_logo)
      expect(shop.logo_url).to  match(/logo/)
    end
  end

end
