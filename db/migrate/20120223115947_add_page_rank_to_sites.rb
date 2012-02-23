class AddPageRankToSites < ActiveRecord::Migration
  def change
    add_column :sites, :page_rank, :integer

  end
end
