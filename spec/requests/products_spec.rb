require 'rails_helper'

RSpec.describe "Admin::Products", :type => :request do
  include AuthHelper

  describe "Guest" do
    describe "GET /admin/products" do
      it 'should be denied' do
        get admin_products_path
        expect(response.status).to be(401)
      end
    end
  end

end
