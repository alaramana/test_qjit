class AddColumnTotalRatingsToExamQuestions < ActiveRecord::Migration
  def change
    add_column :exam_questions, :total_ratings, :decimal, :default => 0
  end
end
