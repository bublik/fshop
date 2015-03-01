class QuestionDecorator < Draper::Decorator
  delegate_all

  def title
    "#{object.username}, #{object.created_at.to_s(:short)}"
  end

  def dom_id
    h.dom_id object.object
  end

  def product_image
    object.product.decorate.thumb_image
  end

  def email
    h.mail_to(object.email)
  end

  def message
    h.simple_format(object.message)
  end

  private
  def product
    object.product.decorate
  end
end
