class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :medical_case_id
      t.text :question_prompt
      t.string :correct_answer
      t.string :correct_answer_explanation
      t.string :incorrect_answer_1
      t.string :incorrect_answer_1_explanation
      t.string :incorrect_answer_2
      t.string :incorrect_answer_2_explanation
      t.string :incorrect_answer_3
      t.string :incorrect_answer_3_explanation

      t.timestamps
    end
  end
end
