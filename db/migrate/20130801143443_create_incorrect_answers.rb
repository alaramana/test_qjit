class CreateIncorrectAnswers < ActiveRecord::Migration
  def change
    create_table :incorrect_answers do |t|
      t.integer :exam_question_id
      t.string :answer
      t.string :explanation
      t.integer :seqence

      t.timestamps
    end
  end
end
