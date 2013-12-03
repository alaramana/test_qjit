class AddColumnBeltToUsers < ActiveRecord::Migration
  def change
    add_column :users, :belt, :string,  :default => "white",  :limit => 40
  end
end
