class AddOptColumnToShop < ActiveRecord::Migration
  def change
    change_table :shops do |t|
      t.boolean :opt, default: false
    end
  end
end
