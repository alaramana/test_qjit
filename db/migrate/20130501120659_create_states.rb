class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name, :null => false, :limit => 50
      t.string :code, :limit => 3
      t.timestamps
    end
    add_index :states, :name, :unique => true
  end
end
