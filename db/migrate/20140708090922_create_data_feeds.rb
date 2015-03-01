class CreateDataFeeds < ActiveRecord::Migration
  def change
    create_table :data_feeds do |t|
      t.references :shop, index: true
      t.string :url
      t.integer :feed_type, default: 0

      t.timestamps
    end
  end
end
