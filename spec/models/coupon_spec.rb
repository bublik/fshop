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

require 'rails_helper'

RSpec.describe Coupon, :type => :model do

  subject(:coupon) { FactoryGirl.build(:coupon) }

  describe 'Validates' do
    it { should be_valid }
    #it { should validate_presence_of(:name) }
  end

end
