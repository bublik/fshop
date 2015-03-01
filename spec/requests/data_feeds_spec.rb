require 'rails_helper'

RSpec.describe "DataFeeds", :type => :request do

  describe "GET /admin/shops/1/data_feeds" do
    let(:shop){ FactoryGirl.create(:shop)}

    it "works!" do
      get admin_shop_data_feeds_path(shop.id)
      expect(response.status).to be(401)
    end

  end
end
