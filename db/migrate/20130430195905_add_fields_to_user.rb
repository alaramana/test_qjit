class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :firstname,               :string,    :null => false, :limit => 40
    add_column :users, :lastname,                :string,    :null => false, :limit => 40
    add_column :users, :username,                :string
    add_column :users, :medical_organization_id, :integer,   :null => false
    add_column :users, :address1,                :string,    :null => false, :limit => 50
    add_column :users, :address2,                :string,    :null => true,  :limit => 50
    add_column :users, :city,                    :string,    :null => false, :limit => 50
    add_column :users, :state_id,                :integer,   :null => false
    add_column :users, :zip,                     :string,    :null => false, :limit => 10
    add_column :users, :phone,                   :string,    :null => false, :limit => 50
    add_column :users, :active,                  :boolean,   :default => true
    add_column :users, :role_id,                 :integer,   :default => 0
    add_column :users, :recent_session_time,     :integer,   :default => 0
    add_column :users, :session_sign_in_count,   :integer,   :default => 0
    add_column :users, :session_total_hours,     :integer,   :default => 0
    add_column :users, :average_session_time,    :integer,   :default => 0    
  end
end
