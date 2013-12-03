class AddCountsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :questions_count, :integer,  :default => 0
    add_column :users, :cases_count, :integer,  :default => 0
    add_column :users, :comments_count, :integer,  :default => 0
  end
end
