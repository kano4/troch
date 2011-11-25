class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name, :null => false
      t.string :url
      t.string :domain_url
      t.date :domain_expired
      t.string :ssl_url
      t.date :ssl_expired
      t.string :watch_method, :null => false

      t.timestamps
    end
  end
end
