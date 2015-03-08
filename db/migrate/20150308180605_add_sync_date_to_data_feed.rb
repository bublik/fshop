class AddSyncDateToDataFeed < ActiveRecord::Migration
  def change
    change_table :data_feeds do |t|
      t.datetime :sync_date
    end
  end
end
