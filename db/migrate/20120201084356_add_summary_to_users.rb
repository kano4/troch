class AddSummaryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :summary, :boolean, :default => false
  end
end
