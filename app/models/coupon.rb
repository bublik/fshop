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

class Coupon < ActiveRecord::Base
  belongs_to :shop

end
