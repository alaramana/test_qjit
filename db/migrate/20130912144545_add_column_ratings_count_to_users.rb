class AddColumnRatingsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ratings_count, :integer
  end
end
