require 'rails_helper'

RSpec.describe ProductsController, :type => :controller do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'search'" do
    it "returns http success" do
      Product.create_index
      product = FactoryGirl.create :verified_product
      ElasticClient.index(index: Product.index_name, type: Product.document_type, id: product.id, body: product.as_indexed_json)
      get 'search'
      expect(response).to be_success
    end
  end

  describe 'GO page' do
    render_views
    let(:coupon) { FactoryGirl.create(:coupon) }
    let(:shop) { FactoryGirl.create(:shop) }

    it 'should redirect to root path when no options' do
      get :go, {shop_id: shop.id}
      expect(response).to be_redirect
    end

    it 'should render page when coupon_id present' do
      get :go, {coupon_id: coupon.id, shop_id: shop.id}
      expect(response).to be_success
    end

    it 'should render page when target url present' do
      get :go, {url: coupon.target_url, shop_id: shop.id}
      expect(response).to be_success
    end

    it 'should render page when coupon_id and target_url' do
      get :go, {coupon_id: coupon.id, url: coupon.target_url, shop_id: shop.id}
      expect(response).to be_success
      expect(response.body).to match(coupon.target_url)
    end

    it 'should redirect to url from prams when coupon dont have target_url' do
      coupon.update_columns({target_url: nil})

      get :go, {coupon_id: coupon.id, url: 'http://coole.com', shop_id: shop.id}
      expect(response).to be_success
      expect(response.body).to match('http://coole.com')
    end
  end

end
