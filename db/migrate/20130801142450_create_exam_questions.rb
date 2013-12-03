class CreateExamQuestions < ActiveRecord::Migration
  def change
    create_table :exam_questions do |t|
      t.text    :question_prompt
      t.integer :objective_id
      t.integer :creator_id
      t.text    :educational_purpose
      t.integer :medical_case_id
      t.string  :correct_answer
      t.string  :correct_answer_explanation
      t.string  :incorrect_1
      t.string  :incorrect_1_explanation
      t.string  :status, :default => "approved"
      t.timestamps
    end
  end
end
