class AddCutTagToSites < ActiveRecord::Migration
  def change
    add_column :sites, :cut_tag, :string

  end
end
