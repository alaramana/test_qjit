class CreateTableInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string  :email,              :null => false, :default => ""
      t.integer :role_id
      t.string  :invitation_token
      t.boolean :status, :default => false
      t.integer :invitor_id, :references => :users
      t.integer :medical_organization_id, :references => :medical_organizations
      t.timestamps
    end
    add_index :invites, :email,            :unique => true
    add_index :invites, :invitation_token, :unique => true
  end
end
