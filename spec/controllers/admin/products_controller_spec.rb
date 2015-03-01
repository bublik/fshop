require 'rails_helper'

RSpec.describe Admin::ProductsController, :type => :controller do
  include AuthHelper

  describe "Guest" do
    it "#index should require authorization" do
      get 'index'
      expect(response.status).to be(401)
    end

    it "#verification should require authorization" do
      get 'verification'
      expect(response.status).to be(401)
    end

    it "#identification should require authorization" do
      get 'verification'
      expect(response.status).to be(401)
    end

  end

  describe "Admin" do
    before do
      http_login()
    end
    let(:product) { FactoryGirl.create(:product) }
    let(:valid_attributes) { FactoryGirl.build(:product).attributes.except('state').except('sync_hash') }
    let(:invalid_attributes) {
      attr = valid_attributes
      attr['name'] = ''
      attr
    }

    describe "GET index" do
      it "assigns all products as @products" do
        product = FactoryGirl.create(:product, state: 'published')
        get :index, {}
        expect(assigns(:products)).to eq([product])
      end
    end

    describe "GET verification" do
      it "assigns all products as @products" do
        product = FactoryGirl.create(:product)
        get :verification, {}
        expect(assigns(:products)).to eq([product])
      end
    end

    describe "GET identification" do
      it "assigns all products as @products" do
        product = FactoryGirl.create(:product, state: 'identified')
        get :identification, {}
        expect(assigns(:product)).to eq(product)
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:product) { FactoryGirl.create(:product, state: 'identified') }
        let(:new_attributes) { {name: 'new_name'} }

        it "updates the requested product" do
          put :update, {:id => product.to_param, :product => new_attributes}
          product.reload
          expect(product.name).to eq(new_attributes[:name])
        end

        it "state should be switched to published" do
          put :update, {:id => product.to_param, :product => new_attributes}
          product.reload
          expect(product.published?).to eq(true)
        end

        it "assigns the requested product as @product" do
          put :update, {:id => product.id, :product => valid_attributes}
          expect(assigns(:product)).to eq(product)
        end

        it "redirects to the product" do
          put :update, {:id => product.id, :product => valid_attributes}
          expect(response).to redirect_to(identification_admin_products_path)
        end
      end

      describe "with invalid params" do
        it "assigns the product as @product" do
          put :update, {:id => product.to_param, :product => invalid_attributes}
          expect(assigns(:product)).to eq(product)
        end

        it "re-renders the 'edit' template" do
          put :update, {:id => product.to_param, :product => invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do

      it "destroy should not remove product from db" do
        product
        expect {
          delete :destroy, {:id => product.to_param}
        }.to change(Product, :count).by(0)
      end

      it 'should mark product as hidden' do
        delete :destroy, {:id => product.to_param}
        product.reload
        expect(product.state).to eq('deleted')
      end

      it "redirects to the products list" do
        product = Product.create! valid_attributes.merge(sync_hash: Time.now.to_i)
        delete :destroy, {:id => product.to_param}
        expect(response).to redirect_to(admin_products_path)
      end
    end
  end

end
