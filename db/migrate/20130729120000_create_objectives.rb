class CreateObjectives < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
    	t.string   "name",   :limit => 75, :null => false
    	t.boolean  "status", :default => true
      t.timestamps
    end
  end
end
