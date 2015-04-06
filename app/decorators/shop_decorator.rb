class ShopDecorator < Draper::Decorator
  delegate_all

  def logo
    h.image_tag(object.logo_url, alt: object.name)
  end

  def opt
    object.opt? ? h.content_tag(:span, 'оптовая цена', class: 'label label-primary') : ''
  end
end
