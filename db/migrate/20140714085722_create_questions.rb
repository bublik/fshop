class CreateQuestions < ActiveRecord::Migration
  def up
    create_table :questions do |t|
      t.text :product_id, limit: 100, index: true
      t.string :username
      t.string :email
      t.text :message
      t.integer :state, default: 0

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end

    add_index :questions, :state
    add_index :questions, :parent_id
  end

  def down
    remove_index :questions, :state
    remove_index :questions, :parent_id
    remove_table :questions
  end
end
