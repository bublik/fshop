class Linen < Product
  acts_as_taggable_on :linen_category, :linen_size, :linen_occasion, :linen_length, :linen_colour, :linen_textile, :linen_item_type, :linen_style
  VISIBLE_TAGS = [:linen_category, :linen_size, :linen_occasion, :linen_length, :linen_colour, :linen_textile, :linen_item_type, :linen_style].freeze
  include Searchable

  def tag_types
    self.class.tag_types
  end

  def visible_tags
    Linen::VISIBLE_TAGS
  end
end
