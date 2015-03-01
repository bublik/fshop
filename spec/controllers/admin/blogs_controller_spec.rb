require 'rails_helper'

RSpec.describe Admin::BlogsController, :type => :controller do
  include AuthHelper

  describe 'Admin' do
    let(:valid_attributes) { FactoryGirl.build(:blog).attributes }

    let(:invalid_attributes) {
      attrs = valid_attributes
      attrs['title'] = nil
      attrs
    }

    before do
      http_login()
    end

    describe "GET index" do
      it "assigns all blogs as @blogs" do
        blog = Blog.create! valid_attributes
        get :index, {}
        expect(assigns(:blogs)).to eq([blog])
      end
    end

    describe "GET new" do
      it "assigns a new blog as @blog" do
        get :new, {}
        expect(assigns(:blog)).to be_a_new(Blog)
      end
    end

    describe "GET edit" do
      it "assigns the requested blog as @blog" do
        blog = Blog.create! valid_attributes
        get :edit, {:id => blog.to_param}
        expect(assigns(:blog)).to eq(blog)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Blog" do
          expect {
            post :create, {:blog => valid_attributes}
          }.to change(Blog, :count).by(1)
        end

        it "assigns a newly created blog as @blog" do
          post :create, {:blog => valid_attributes}
          expect(assigns(:blog)).to be_a(Blog)
          expect(assigns(:blog)).to be_persisted
        end

        it "redirects to the created blog" do
          post :create, {:blog => valid_attributes}
          expect(response).to redirect_to(admin_blogs_path)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved blog as @blog" do
          post :create, {:blog => invalid_attributes}
          expect(assigns(:blog)).to be_a_new(Blog)
        end

        it "re-renders the 'new' template" do
          post :create, {:blog => invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) { {title: 'pretty title'} }

        it "updates the requested blog" do
          blog = Blog.create! valid_attributes
          put :update, {:id => blog.to_param, :blog => new_attributes}
          blog.reload
          expect(blog.title).to eq(new_attributes[:title])
        end

        it "assigns the requested blog as @blog" do
          blog = Blog.create! valid_attributes
          put :update, {:id => blog.to_param, :blog => valid_attributes}
          expect(assigns(:blog)).to eq(blog)
        end

        it "redirects to the blog" do
          blog = Blog.create! valid_attributes
          put :update, {:id => blog.to_param, :blog => valid_attributes}
          expect(response).to redirect_to(admin_blogs_path)
        end
      end

      describe "with invalid params" do
        it "assigns the blog as @blog" do
          blog = Blog.create! valid_attributes
          put :update, {:id => blog.to_param, :blog => invalid_attributes}
          expect(assigns(:blog)).to eq(blog)
        end

        it "re-renders the 'edit' template" do
          blog = Blog.create! valid_attributes
          put :update, {:id => blog.to_param, :blog => invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested blog" do
        blog = Blog.create! valid_attributes
        expect {
          delete :destroy, {:id => blog.to_param}
        }.to change(Blog, :count).by(-1)
      end

      it "redirects to the blogs list" do
        blog = Blog.create! valid_attributes
        delete :destroy, {:id => blog.to_param}
        expect(response).to redirect_to(admin_blogs_url)
      end
    end

  end
end
