class RemoveDefaultNullToUsers < ActiveRecord::Migration
  def up
  	change_column :users, :state_id, :integer, :null => true
  end

  def down
  	change_column :users, :state_id, :integer
  end
end
