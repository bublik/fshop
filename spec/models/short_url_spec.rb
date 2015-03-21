# == Schema Information
#
# Table name: short_urls
#
#  id          :integer          not null, primary key
#  seo_url     :string
#  full_url    :string(1024)
#  title       :string
#  description :string
#  keywords    :string
#  style_typs  :text
#  filter      :string
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe ShortUrl, :type => :model do
  subject(:short_url) { FactoryGirl.build(:short_url) }

  describe 'Validate' do

    it { should be_valid }
    it { should validate_presence_of(:seo_url) }
    it { should validate_presence_of(:full_url) }
    it { should validate_uniqueness_of(:seo_url) }
  end

  describe 'Search params' do
    let(:short_url) { FactoryGirl.build(:short_url) }
    before (:each) do
      short_url.full_url = 'http://staging.fshop.com.ua/products/search/?utf8=%E2%9C%93&product%5Bcolour%5D%5B%5D=black&product%5Bcolour%5D%5B%5D=blue&product%5Blength%5D%5B%5D=above-knee&product%5Blength%5D%5B%5D=mini&product%5Bbody_type%5D%5B%5D=apple&product%5Bprice%5D%5Bmin%5D=0&product%5Bprice%5D%5Bmax%5D=79'
      short_url.store_filter
    end

    it 'should store filter as hash' do
      expect(short_url.filter).to be_kind_of(Hash)
    end

    it 'should not have utf8 as key' do
      expect(short_url.filter.has_key?(['utf8'])).to eq(false)
    end

    it 'should have max price 79' do
      expect(short_url.filter['price']['max']).to eq('79')
    end

    it 'should have colour *blue*' do
      expect(short_url.filter['colour']).to include('black')
    end

    it 'should have *q* search word' do
      short_url.full_url = 'http://localhost.dev:3000/products/search/?utf8=%E2%9C%93&q=wedding&product%5Bcolour%5D%5B%5D=blue&product%5Bprice%5D%5Bmin%5D=0&product%5Bprice%5D%5Bmax%5D=9900'
      short_url.store_filter
      expect(short_url.filter['q']).to include('wedding')
      expect(short_url.filter['colour']).to include('blue')
      expect(short_url.filter['price']['max']).to eq('9900')
    end
  end

  describe 'url with TAG' do
    it 'should store seach filter' do
      short_url.full_url = 'http://localhost.dev:3000/products/tag/blue/colour'
      short_url.store_filter
      expect(short_url.filter['colour']).to include('blue')
    end

    it ' filter should be array' do
      short_url.full_url = 'http://localhost.dev:3000/products/tag/blue/colour'
      short_url.store_filter
      expect(short_url.filter['colour']).to be_kind_of(Array)
    end
  end

end
