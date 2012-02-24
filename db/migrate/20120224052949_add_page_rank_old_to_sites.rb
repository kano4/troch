class AddPageRankOldToSites < ActiveRecord::Migration
  def change
    add_column :sites, :page_rank_old, :integer

  end
end
