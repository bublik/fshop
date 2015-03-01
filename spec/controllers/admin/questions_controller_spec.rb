require 'rails_helper'

RSpec.describe Admin::QuestionsController, :type => :controller do
  include AuthHelper

  let(:valid_attributes) {
    question = FactoryGirl.build(:question)
    attrs = {}
    attrs[:username] = question.username
    attrs[:email] = question.email
    attrs[:message] = question.message
    attrs[:product_id] = question.product_id
    attrs
  }

  let(:invalid_attributes) { valid_attributes.except(:product_id) }
  let(:create_question) { FactoryGirl.create(:question, product: FactoryGirl.create(:verified_product)) }

  before do
    http_login()
  end

  describe "GET index" do
    it "assigns all questions as @questions" do
      question = create_question
      get :index, {state: 'pending'}
      expect(assigns(:questions)).to eq([question])
    end
  end

  describe "GET new" do
    it "assigns a new question as @question" do
      get :new, {}
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe "GET edit" do
    it "assigns the requested question as @question" do
      question = create_question
      get :edit, {:id => question.to_param}
      expect(assigns(:question)).to eq(question)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Question" do
        expect {
          post :create, {:question => valid_attributes}
        }.to change(Question, :count).by(1)
      end

      it "assigns a newly created question as @question" do
        post :create, {:question => valid_attributes}
        expect(assigns(:question)).to be_a(Question)
        expect(assigns(:question)).to be_persisted
      end

      it "redirects to the created question" do
        post :create, {:question => valid_attributes}
        expect(response).to redirect_to(admin_questions_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved question as @question" do
        post :create, {:question => invalid_attributes}
        expect(assigns(:question)).to be_a_new(Question)
      end

      it "re-renders the 'new' template" do
        post :create, {:question => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) { {username: 'updated_user_name'} }

      it "updates the requested question" do
        put :update, {:id => create_question.to_param, :question => new_attributes}
        create_question.reload
        expect(create_question  .username).to eq('updated_user_name')
      end

      it "assigns the requested question as @question" do
        put :update, {:id => create_question.to_param, :question => valid_attributes}
        expect(assigns(:question)).to eq(create_question)
      end

      it "redirects to the question" do
        put :update, {:id => create_question.to_param, :question => valid_attributes}
        expect(response).to redirect_to(admin_questions_path)
      end
    end

    describe "with invalid params" do
      it "assigns the question as @question" do
        put :update, {:id => create_question.to_param, :question => invalid_attributes}
        expect(assigns(:question)).to eq(create_question)
      end

      it "re-renders the 'edit' template" do
        invalid_attributes[:product_id] = nil
        put :update, {:id => create_question.to_param, :question => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested question" do
      expect {
        delete :destroy, {:id => create_question.to_param}
      }.to change(Question, :count).by(0)
    end

    it "redirects to the questions list" do
      delete :destroy, {:id => create_question.to_param}
      expect(response).to redirect_to(admin_questions_url)
    end
  end

end
