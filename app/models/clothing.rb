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
#  type           :string(15)
#

class Clothing < Product
  acts_as_taggable_on :clothing_category, :clothing_size, :clothing_occasion, :clothing_length, :clothing_colour,
                      :clothing_textile, :clothing_item_type, :clothing_style, :clothing_item_shape, :clothing_skirt_type,
                      :clothing_body_type, :clothing_length_of_sleeve, :clothing_neckline_type, :clothing_waistline,
                      :clothing_belt_type
  VISIBLE_TAGS = [:clothing_category, :clothing_style, :clothing_size, :clothing_occasion, :clothing_length, :clothing_colour].freeze
  include Searchable

  def tag_types
    self.class.tag_types
  end

  def visible_tags
    Linen::VISIBLE_TAGS
  end
end
