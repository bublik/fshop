require 'rails_helper'

RSpec.describe "Questions", :type => :request do
  let(:product) { FactoryGirl.create(:product) }

  # describe "POST /questions" do
  #   it "new question" do
  #     post questions_path, {question: {product_id: product.id, username: 'Username', email: 'email@me.com', message: 'long question'}}
  #     expect(response.status).to be(404)
  #   end
  # end

end
