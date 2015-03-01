require 'rails_helper'

RSpec.describe Admin::DataFeedsController, :type => :controller do
  include AuthHelper

  describe "Admin" do

    let(:valid_attributes) { FactoryGirl.build(:data_feed).attributes.merge(feed_type: 'default') }
    let(:invalid_attributes) { valid_attributes.except('url') }

    before(:each) do
      http_login
    end

    describe "GET index" do
      it "assigns all data_feeds as @data_feeds" do
        data_feed = DataFeed.create! valid_attributes
        get :index, {shop_id: valid_attributes['shop_id']}
        expect(assigns(:data_feeds)).to eq([data_feed])
      end
    end

    describe "GET new" do
      it "assigns a new data_feed as @data_feed" do
        get :new, {shop_id: valid_attributes['shop_id']}
        expect(assigns(:data_feed)).to be_a_new(DataFeed)
      end
    end

    describe "GET edit" do
      it "assigns the requested data_feed as @data_feed" do
        data_feed = DataFeed.create! valid_attributes
        get :edit, {shop_id: data_feed.shop_id, id: data_feed.to_param}
        expect(assigns(:data_feed)).to eq(data_feed)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new DataFeed" do
          expect {
            post :create, {shop_id: valid_attributes['shop_id'], data_feed: valid_attributes}
          }.to change(DataFeed, :count).by(1)
        end

        it "assigns a newly created data_feed as @data_feed" do
          post :create, {shop_id: valid_attributes['shop_id'], data_feed: valid_attributes}
          expect(assigns(:data_feed)).to be_a(DataFeed)
          expect(assigns(:data_feed)).to be_persisted
        end

        it "redirects to the created data_feed" do
          post :create, {shop_id: valid_attributes['shop_id'], data_feed: valid_attributes}
          expect(response).to redirect_to(admin_shop_data_feeds_path)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved data_feed as @data_feed" do
          post :create, {shop_id: valid_attributes['shop_id'], data_feed: invalid_attributes}
          expect(assigns(:data_feed)).to be_a_new(DataFeed)
        end

        it "re-renders the 'new' template" do
          post :create, {shop_id: valid_attributes['shop_id'], data_feed: invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          new_attributes = valid_attributes
          new_attributes['url'] = 'http://google.com/products_feed'
          new_attributes
        }

        it "updates the requested data_feed" do
          data_feed = DataFeed.create! valid_attributes
          put :update, {shop_id: valid_attributes['shop_id'], id: data_feed.to_param, data_feed: new_attributes}
          data_feed.reload
          expect(data_feed.url).to match(/google/)
        end

        it "assigns the requested data_feed as @data_feed" do
          data_feed = DataFeed.create! valid_attributes
          put :update, {shop_id: valid_attributes['shop_id'], id: data_feed.to_param, data_feed: valid_attributes}
          expect(assigns(:data_feed)).to eq(data_feed)
        end

        it "redirects to the data_feed" do
          data_feed = DataFeed.create! valid_attributes
          put :update, {shop_id: valid_attributes['shop_id'], id: data_feed.to_param, data_feed: valid_attributes}
          expect(response).to redirect_to(admin_shop_data_feeds_path)
        end
      end

      describe "with invalid params" do
        let(:data_feed) { FactoryGirl.create(:data_feed) }
        let(:invalid_attributes) {
          invalid_attributes = data_feed.attributes
          invalid_attributes['url'] = nil
          invalid_attributes['feed_type'] = 'default'
          invalid_attributes
        }

        it "assigns the data_feed as @data_feed" do
          put :update, {shop_id: data_feed.shop_id, id: invalid_attributes['id'], data_feed: invalid_attributes}
          expect(assigns(:data_feed)).to eq(data_feed)
        end

        it "re-renders the 'edit' template" do
          put :update, {shop_id: data_feed.shop_id, id: invalid_attributes['id'], data_feed: invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested data_feed" do
        data_feed = DataFeed.create! valid_attributes
        expect {
          delete :destroy, {shop_id: valid_attributes['shop_id'], id: data_feed.to_param}
        }.to change(DataFeed, :count).by(-1)
      end

      it "redirects to the data_feeds list" do
        data_feed = DataFeed.create! valid_attributes
        delete :destroy, {shop_id: valid_attributes['shop_id'], id: data_feed.to_param}
        expect(response).to redirect_to(admin_shop_data_feeds_url)
      end
    end
  end

end
