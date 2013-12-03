class AddColumnExamQuestionToScoreBoards < ActiveRecord::Migration
  def change
    add_column :score_boards, :exam_question_id, :integer
  end
end
