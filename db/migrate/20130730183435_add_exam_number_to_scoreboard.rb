class AddExamNumberToScoreboard < ActiveRecord::Migration
  def change
    add_column :score_boards, :exam_number, :integer, :null => false, :default => 1
  end
end
