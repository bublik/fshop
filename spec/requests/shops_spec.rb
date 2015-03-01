require 'rails_helper'

RSpec.describe "Admin::Shops", :type => :request do

  describe "Guest" do

    describe "GET /admin/shops" do
      it "should be denied" do
        get admin_shops_path
        expect(response.status).to be(401)
      end

      it "should redirect to shops list" do
        get '/admin'
        expect(response).to redirect_to(admin_products_path)
      end
    end

  end

end
