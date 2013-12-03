class CreateMedicalOrganizations < ActiveRecord::Migration
  def change
    create_table :medical_organizations do |t|
      t.string  :name,    :null => false, :limit => 75
      t.boolean :status,  :null => false, :default => false
      t.timestamps
    end
    add_index :medical_organizations, :name, :unique => true
  end
end
