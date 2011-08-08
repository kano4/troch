class CreateWatchLogs < ActiveRecord::Migration
  def change
    create_table :watch_logs do |t|
      t.integer :site_id
      t.string :status
      t.text :content
      t.integer :response_time

      t.timestamps
    end
  end
end
