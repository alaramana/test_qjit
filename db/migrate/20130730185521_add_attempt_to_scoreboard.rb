class AddAttemptToScoreboard < ActiveRecord::Migration
  def change
    add_column :score_boards, :attempt, :integer, :null => false, :default => 1
  end
end
