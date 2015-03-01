# == Schema Information
#
# Table name: shops
#
#  id                            :integer          not null, primary key
#  name                          :string(255)
#  shipping                      :text
#  affiliate_network_id          :string(255)
#  affiliate_network_merchant_id :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime
#  logo                          :string(255)
#  data_feeds_count              :integer          default(0)
#  target_url                    :string(500)
#

class Shop < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  has_many :data_feeds, dependent: :delete_all
  has_many :products, dependent: :destroy
  has_many :coupons, dependent: :delete_all

  validates_presence_of :name, :shipping, :affiliate_network_id, :affiliate_network_merchant_id, :target_url
  validates_uniqueness_of :name, :affiliate_network_id
  # TOD move destroy shop do sidekiq

end
