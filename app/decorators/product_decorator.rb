class ProductDecorator < Draper::Decorator
  delegate_all

  def shop
    _shop.name
  end

  def shop_logo
    _shop.logo.url
  end

  def shipping_info
    h.simple_format(_shop.shipping)
  end

  def image(style_class = '')
    h.image_tag(object.image.url, class: style_class, alt: object.name)
  end

  def image_responsive
    h.image_tag(object.image.preview.url, class: 'img-responsive', alt: object.name)
  end

  def preview_image
    h.image_tag(object.image.preview.url, alt: object.name)
  end

  def thumb_image
    h.image_tag(object.image.thumb.url, alt: object.name)
  end

  def description
    h.simple_format(object.description, class: 'description')
  end

  def price
    price_with_currency(object.price)
  end

  def original_price
    price_with_currency(object.original_price)
  end

  def admin_tags_list
    tag_type_rows = h.tag_types(object).collect do |tag_type|
      tags = object.tags_on(tag_type).map(&:name)
      tags.blank? ? nil :
        "#{I18n.t(tag_type)}: " + tags.collect { |tag| h.content_tag(:span, tag, class: 'label label-default') }.join(' ')
    end.compact

    tag_type_rows.collect do |tags_row|
      h.content_tag(:div, tags_row.html_safe, class: 'tags')
    end.join('').html_safe
  end

  private
  def _shop
    object.shop
  end

  def price_with_currency(cents)
    h.content_tag(:span, h.number_to_currency(cents, unit: object.currency), class: 'price')
  end
end
