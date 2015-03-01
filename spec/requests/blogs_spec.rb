require 'rails_helper'

RSpec.describe "Blogs", :type => :request do
  let(:blog) { FactoryGirl.create(:blog) }

  describe "GET /blogs" do
    it "Should return posts list" do
      get blogs_path
      expect(response.status).to be(200)
    end
  end

  describe 'Get /blogs/:id' do
    it 'should return post page' do
      get blog_path(blog)
      expect(response.status).to be(200)
    end
  end

end
