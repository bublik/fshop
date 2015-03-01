class Notifications < ActionMailer::Base
  default from: "admin@fshop.com.ua"
  layout 'email'

  def contact_us(question)
    @question = question

    mail to: "admin@fshop.com.ua", subject: 'Обратная связь' do |format|
      format.text
      format.html
    end
  end

end
