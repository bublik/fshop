class DataFeedDecorator < Draper::Decorator
  delegate_all

  def shop
    object.shop.name
  end

end
