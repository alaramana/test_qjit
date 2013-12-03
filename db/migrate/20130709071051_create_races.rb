class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string  :name,    :null => false, :limit => 75
      t.boolean :status,  :null => false, :default => true
      t.timestamps
    end
  end
end
