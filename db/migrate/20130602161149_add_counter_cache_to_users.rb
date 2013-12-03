class AddCounterCacheToUsers < ActiveRecord::Migration
  def change
    add_column :medical_organizations, :users_count, :integer, :default => 0
  end
end
