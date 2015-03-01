class AddTargetUtToShop < ActiveRecord::Migration
  def up
    add_column :shops, :target_url, :string, limit: 500
  end

  def down
    remove_column :shops, :target_url
  end

end
