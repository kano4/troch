class AddGroupToSites < ActiveRecord::Migration
  def change
    add_column :sites, :group_id, :integer

  end
end
