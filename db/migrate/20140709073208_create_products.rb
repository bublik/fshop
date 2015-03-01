class CreateProducts < ActiveRecord::Migration
  def up
    create_table(:products, id: false) do |t|
      t.string :sync_hash, limit: 100, null: false
      t.references :shop, index: true
      t.string :sku, limit: 100
      t.string :slug
      t.string :name
      t.string :description, limit: 2000
      t.string :link, limit: 512
      t.string :brand, limit: 100
      t.string :keywords, limit: 500
      t.string :currency, limit: 3
      t.string :original_image, limit: 512
      t.string :image
      t.integer :original_price
      t.integer :price
      t.string :gender, limit: 20
      t.integer :state, default: 0

      t.timestamps
    end

    execute "ALTER TABLE products ADD PRIMARY KEY (sync_hash)"

    add_index :products, :name
    add_index :products, :price
    add_index :products, :state
    add_index :products, :slug
  end

  def down
    drop_table :products

    remove_index :products, :name
    remove_index :products, :price
    remove_index :products, :state
    remove_index :products, :slug
    remove_index :products, :shop_id
  end
end


