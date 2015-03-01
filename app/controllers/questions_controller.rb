class QuestionsController < ApplicationController

  # GET /questions/new
  def new
    @question = Question.new
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question.product, notice: 'Вопрос успешно отправлен.' }
      else
        format.html { redirect_to @question.product, error: 'Пожалуйста заполните все поля!' }
      end
      format.js
    end
  end

  private
  def question_params
    params.require(:question).permit(:product_id, :username, :email, :message)
  end
end
