require 'rails_helper'

RSpec.describe HomeController, :type => :controller do
  let!(:product) { FactoryGirl.create(:product, state: 'published') }
  let!(:blog) { FactoryGirl.build(:blog) }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      expect(response).to be_success
    end
  end

  describe "GET 'terms'" do
    it "returns http success" do
      get 'terms'
      expect(response).to be_success
    end
  end

  describe "GET 'privacy'" do
    it "returns http success" do
      get 'privacy'
      expect(response).to be_success
    end
  end

  describe "GET 'faq'" do
    it "returns http success" do
      get 'faq'
      expect(response).to be_success
    end
  end


  describe "GET 'contact_us'" do
    it "returns http success" do
      get 'contact_us'
      expect(response).to be_success
    end
  end

  describe "POST 'contact_us'" do
    it "returns http success" do
      post 'contact_us', {question: {username: 'Guest', email: 'guest@example.com', message: 'Guest question'}}
      expect(response).to be_success
      expect(flash[:notice]).to be_present
    end
  end

end
