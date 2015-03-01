class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :preview
      t.text :body
      t.string :slug

      t.timestamps
    end
    add_index :blogs, :slug, unique: true
  end
end
