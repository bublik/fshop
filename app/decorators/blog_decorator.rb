class BlogDecorator < Draper::Decorator
  delegate_all

  def date
    h.content_tag(:span, I18n.l(object.updated_at, format: :long), class: 'post-date')
  end

end
