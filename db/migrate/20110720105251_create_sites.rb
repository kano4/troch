class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name, :null => false
      t.string :url, :null => false
      t.text :content
      t.string :domain_url
      t.date :domain_expired
      t.string :ssl_url
      t.date :ssl_expired

      t.timestamps
    end
  end
end
