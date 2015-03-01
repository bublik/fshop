require 'rails_helper'

RSpec.describe Admin::ShopsController, :type => :controller do
  include AuthHelper

  describe "Guest" do
    describe "GET 'index'" do
      it "should require authorization" do
        get 'index'
        expect(response.status).to be(401)
      end
    end
  end

  describe "Admin" do
    let(:shop) { FactoryGirl.create(:shop) }
    let(:valid_attributes) { FactoryGirl.build(:shop).attributes.except('id') }

    before do
      http_login()
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        expect(response).to be_success
      end
    end

    describe "GET 'new'" do
      it "returns http success" do
        get 'new'
        expect(response).to be_success
      end
    end

    describe 'Create' do
      it 'should create new shop in db' do
        expect { post :create, {shop: valid_attributes} }.to change(Shop, :count).by(1)
      end
    end

    describe 'Update' do
      let(:new_attributes) { {name: 'New name'} }
      it 'should change attribute for shop' do
        shop
        put :update, {:id => shop.to_param, :shop => new_attributes}
        shop.reload
        expect(shop.name).to eq(new_attributes[:name])
      end
    end

    describe 'Destroy' do
      it 'should change attribute for shop' do
        shop
        expect {
          delete :destroy, {:id => shop.to_param}
        }.to change(Shop, :count).by(-1)
      end
    end
  end

end
