class HomeController < ApplicationController

  def index
    @products = Product.last_records.map(&:decorate)
    @blogs = Blog.last_records
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def contact_us
    if request.post?
      question_params = params.require(:question).permit(:username, :email, :message)
      @question = Question.new(question_params)
      @question.feedback = true
     if @question.valid? && Notifications.contact_us(@question).deliver
       flash[:notice] = 'Your question was sent.'
       @question = Question.new
     end
    else
      @question = Question.new
    end

  end

  def faq

  end
end
