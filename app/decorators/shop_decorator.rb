class ShopDecorator < Draper::Decorator
  delegate_all

  def logo
    h.image_tag(object.logo_url, alt: object.name)
  end

end
