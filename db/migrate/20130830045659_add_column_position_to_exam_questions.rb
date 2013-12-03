class AddColumnPositionToExamQuestions < ActiveRecord::Migration
  def change
    add_column :exam_questions, :position, :string
  end
end
