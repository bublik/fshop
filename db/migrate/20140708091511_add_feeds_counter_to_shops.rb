class AddFeedsCounterToShops < ActiveRecord::Migration
  def change
    add_column :shops, :data_feeds_count, :integer, default: 0
  end
end
