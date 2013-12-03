class ChangeColumnToQuestions < ActiveRecord::Migration
  def up
  	change_column :exam_questions, :correct_answer_explanation, :text
  	change_column :exam_questions, :incorrect_1_explanation, :text
  	change_column :incorrect_answers, :explanation, :text
  end

  def down
  	change_column :exam_questions, :correct_answer_explanation, :string
  	change_column :exam_questions, :incorrect_1_explanation, :string
	  change_column :incorrect_answers, :explanation, :string
  end
end
