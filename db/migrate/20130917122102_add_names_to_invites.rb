class AddNamesToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :invitor_name, :string
    add_column :invites, :medical_organization_name, :string
    add_column :invites, :role_name, :string
  end
end
