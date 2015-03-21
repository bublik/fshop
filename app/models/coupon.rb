# == Schema Information
#
# Table name: coupons
#
#  id         :integer          not null, primary key
#  shop_id    :integer
#  name       :string
#  code       :string
#  start_date :datetime
#  end_date   :datetime
#  target_url :string(500)
#  created_at :datetime
#  updated_at :datetime
#

class Coupon < ActiveRecord::Base
  belongs_to :shop

end
