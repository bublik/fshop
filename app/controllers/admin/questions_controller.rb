class Admin::QuestionsController < AdminController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :mark_as_valid]

  def index
    @questions = Question.newest
    @questions = @questions.by_state(params[:state]) if params[:state].present?
    @questions = @questions.page(params[:page]).per(5)
  end

  def new
    @question = Question.new(parent_id: params[:parent_id])

    @original_question = params[:parent_id] ? @question.parent.decorate : nil
  end

  def edit
  end

  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save && @question.verified!
        format.html { redirect_to admin_questions_url, notice: 'Answer was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to admin_questions_url, notice: 'Question was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def mark_as_valid
    @question.verified!
    respond_to do |format|
      format.html { redirect_to admin_questions_url, notice: 'Question was successfully updated.' }
      format.js {}
    end
  end

  def destroy
    @question.deleted!
    respond_to do |format|
      format.html { redirect_to admin_questions_url, notice: 'Question was successfully destroyed.' }
      format.js {}
    end
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:product_id, :parent_id, :username, :email, :message)
  end
end
