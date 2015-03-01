require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do

  let!(:product) { FactoryGirl.create(:product) }
  let(:valid_attributes) {
    question = FactoryGirl.build(:question, product: product)
    attrs = {}
    attrs[:username] = question.username
    attrs[:email] = question.email
    attrs[:message] = question.message
    attrs[:product_id] = product.id
    attrs
  }

  let(:invalid_attributes) { valid_attributes.except(:message) }

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Question" do
        expect {
          post :create, {question: valid_attributes}
        }.to change(Question, :count).by(1)
      end

      it "assigns a newly created question as @question" do
        post :create, {question: valid_attributes}
        expect(assigns(:question)).to be_a(Question)
        expect(assigns(:question)).to be_persisted
      end

      it "redirects to product page" do
        post :create, {question: valid_attributes}
        expect(response).to redirect_to(product)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved question as @question" do
        post :create, {question: invalid_attributes}
        expect(assigns(:question)).to be_a_new(Question)
      end

      it "should render create for JS request" do
        post :create, {question: invalid_attributes, format: :js}
        expect(response).to render_template("questions/create")
      end
      it "should redirect to product for HTML request" do
        post :create, {question: invalid_attributes}
        expect(response).to redirect_to(product)
      end

    end
  end

end
