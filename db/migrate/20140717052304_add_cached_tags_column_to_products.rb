class AddCachedTagsColumnToProducts < ActiveRecord::Migration
  def up
    add_column :products, :cached_tags, :text
  end

  def down
    remove_column :products, :cached_tags
  end
end
