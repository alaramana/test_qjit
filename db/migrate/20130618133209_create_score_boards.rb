class CreateScoreBoards < ActiveRecord::Migration
  def change
    create_table :score_boards do |t|
      t.integer  :user_id
      t.integer  :medical_case_id
      t.boolean  :correct
      t.string   :status
      t.string   :answer
      t.string   :time_taken
      t.string   :exam_mode
      t.timestamps
    end
  end
end
