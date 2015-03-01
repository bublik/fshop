class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.text :shipping
      t.string :affiliate_network_id
      t.string :affiliate_network_merchant_id

      t.timestamps
    end
  end
end
