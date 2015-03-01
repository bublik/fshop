require 'rails_helper'

RSpec.describe BlogsController, :type => :controller do
  let(:blog) { FactoryGirl.create(:blog) }

  describe "GET index" do
    it "assigns all blogs as @blogs" do
      get :index
      expect(assigns(:blogs)).to eq([blog])
    end
  end

  describe "GET show" do
    it "assigns the requested blog as @blog" do
      get :show, {:id => blog.to_param}
      expect(assigns(:blog)).to eq(blog)
    end
  end

end
