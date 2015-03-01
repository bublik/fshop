class AddIsActiveColumnToProducts < ActiveRecord::Migration
  def up
    add_column :products, :is_active, :boolean, default: true
  end

  def down
    remove_column :products, :is_active
  end
end
