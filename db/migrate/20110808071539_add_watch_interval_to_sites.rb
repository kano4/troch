class AddWatchIntervalToSites < ActiveRecord::Migration
  def change
    add_column :sites, :watch_interval, :integer, :null => false, :default => 15
  end
end
