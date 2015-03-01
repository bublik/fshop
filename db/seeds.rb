require 'factory_girl_rails'

200.times do
  shop = FactoryGirl.create(:shop)
  FactoryGirl.create(:data_feed, shop: shop)
  5.times do  FactoryGirl.create(:coupon, shop: shop) end

  product = FactoryGirl.create(:product, shop: shop)

  question = FactoryGirl.create(:question, product: product, state: 'verified')
  FactoryGirl.create(:question, product: product, parent: question, state: 'verified')

  FactoryGirl.create(:question, product: product)
  FactoryGirl.create(:blog)
end
