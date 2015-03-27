class Clothing < Product
  acts_as_taggable_on :clothing_category, :clothing_size, :clothing_occasion, :clothing_length, :clothing_colour,
                      :clothing_textile, :clothing_item_type, :clothing_style, :clothing_item_shape, :clothing_skirt_type,
                      :clothing_body_type, :clothing_length_of_sleeve, :clothing_neckline_type, :clothing_waistline,
                      :clothing_belt_type
  VISIBLE_TAGS = [:clothing_category, :clothing_item_type, :clothing_size, :clothing_occasion, :clothing_length, :clothing_colour].freeze
  include Searchable

  def tag_types
    self.class.tag_types
  end

  def visible_tags
    Linen::VISIBLE_TAGS
  end
end