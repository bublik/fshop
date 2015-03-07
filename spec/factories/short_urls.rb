# == Schema Information
#
# Table name: short_urls
#
#  id          :integer          not null, primary key
#  seo_url     :string(255)
#  full_url    :string(1024)
#  title       :string(255)
#  description :string(255)
#  keywords    :string(255)
#  style_typs  :text
#  filter      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :short_url do
    seo_url "seo_url"
    full_url "http://staging.fshop.com.ua/products/search/?utf8=%E2%9C%93&product%5Bcolour%5D%5B%5D=black&product%5Bcolour%5D%5B%5D=blue&product%5Blength%5D%5B%5D=above-knee&product%5Blength%5D%5B%5D=mini&product%5Bbody_type%5D%5B%5D=apple&product%5Bprice%5D%5Bmin%5D=0&product%5Bprice%5D%5Bmax%5D=79"
    title "MyString"
    description "Description"
    keywords "keywords"
    style_typs "style_typs"
    filter "filter"
  end
end
