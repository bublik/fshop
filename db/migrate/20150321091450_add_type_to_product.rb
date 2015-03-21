class AddTypeToProduct < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.string :type, limit: 15
    end
  end
end
