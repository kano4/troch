class CreateUsersSites < ActiveRecord::Migration
  def change
    create_table :users_sites do |t|
      t.integer :user_id, :null => false
      t.integer :site_id, :null => false

      t.timestamps
    end
  end
end
