class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.references :shop, index: true
      t.string :name
      t.string :code
      t.datetime :start_date
      t.datetime :end_date
      t.string :target_url, limit: 500

      t.timestamps
    end
  end
end
