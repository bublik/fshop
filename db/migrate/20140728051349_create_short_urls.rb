class CreateShortUrls < ActiveRecord::Migration
  def change
    create_table :short_urls do |t|
      t.string :seo_url
      t.string :full_url, limit: 1024
      t.string :title
      t.string :description
      t.string :keywords
      t.text :style_typs
      t.string :filter

      t.timestamps
    end

    add_index :short_urls, :seo_url, unique: true
  end

end
