# == Schema Information
#
# Table name: products
#
#  sync_hash      :string(100)      not null, primary key
#  shop_id        :integer
#  sku            :string(100)
#  slug           :string
#  name           :string
#  description    :string(2000)
#  link           :string(512)
#  brand          :string(100)
#  keywords       :string(500)
#  currency       :string(3)
#  original_image :string(512)
#  image          :string
#  original_price :integer
#  price          :integer
#  gender         :string(20)
#  state          :integer          default("0")
#  created_at     :datetime
#  updated_at     :datetime
#  is_active      :boolean          default("true")
#  cached_tags    :text
#

require 'rails_helper'

RSpec.describe Product, :type => :model do

  subject(:product) { FactoryGirl.build(:product) }

  describe 'Validate' do
    it { should be_valid }

    it { should validate_presence_of(:sku) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:original_image) }
    it { should validate_presence_of(:link) }
    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:original_price) }
    it { should validate_presence_of(:price) }
  end

  describe 'State' do
    before do
      product.save
      allow(product).to receive(:create_thumb) { true }
    end

    it 'should be in draft' do
      expect(product.state).to eq('draft')
    end

    it 'should be changed from draft to deleted' do
      product.hide!
      expect(product.state).to eq('deleted')
    end

    it 'should changed to verified' do
      product.verify!
      expect(product.state).to eq('verified')
    end

    it 'should changed to verified from deleted' do
      product.hide!
      product.verify!
      expect(product.state).to eq('verified')
    end

    it 'should changed to verified' do
      product.verify!
      product.identify!
      expect(product.state).to eq('identified')
    end

    it 'should changed to published' do
      product.verify!
      product.identify!
      product.publish!
      expect(product.state).to eq('published')
    end

  end

  describe 'Thumb' do
    before do
      product.verify!
      Product.create_thumb(product.id)
      product.reload
    end

    after do
      product.image.remove!
    end

    it 'should be created' do
      expect(product.image.url).not_to eq(nil), 'Thumb was not created'
    end

    it 'should switch state to #identified' do
      expect(product.state).to eq('identified')
    end
  end

  describe 'Cashe tags context' do
    let(:context) { :colour }

    after do
      product.flush_cashed_context_tags
    end

    it 'should be blank cashe' do
      expect(Rails.cache.read("cashed_tags_#{context}").blank?).to eq(true)
    end

    it 'sbe blank for product to' do
      expect(product.cashed_context_tags(context)).to eq([])
    end

    it 'should be blank for #colour' do
      expect(product.colour_list).to eq([])
    end

    describe 'with presisted tags' do
      before do
        product.colour_list = 'blue, red'
        product.save
      end

      it 'should create cash for context' do
        expect(product.colour_list).to eq(['blue', 'red'])
      end

      it 'should create chache for context' do
        product.flush_cashed_context_tags
        expect(product.cashed_context_tags(context)).to eq(['blue', 'red'])
      end

      it 'should not create Tags select when cashe already existed' do
        expect(ActsAsTaggableOn::Tagging).not_to receive(:where).with(context: context)
      end

    end
  end

  describe 'Cashe last records' do
    before do
      20.times do
        FactoryGirl.create(:product, state: 'published')
      end
      Product.flush_cache
    end

    it 'should include last records' do
      last = Product.opened.first
      expect(Product.last_records).to include(last)
    end
  end
end
