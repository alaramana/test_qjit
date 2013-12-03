class AddColumnToExamQuestions < ActiveRecord::Migration
  def change
  	add_column :ratings, :exam_question_id, :integer
  	add_column :favorites, :exam_question_id, :integer
  	add_column :exam_questions, :average_rating, :decimal, :null => false, :default => 0
  end
end
