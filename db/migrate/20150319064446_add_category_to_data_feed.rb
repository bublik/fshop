class AddCategoryToDataFeed < ActiveRecord::Migration
  def change
    add_column :data_feeds, :category, :string, null: false, default: 'Clothing'
  end
end
