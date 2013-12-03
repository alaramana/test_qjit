class CreateSpecificExamDetails < ActiveRecord::Migration
  def change
    create_table :specific_exam_details do |t|
      t.integer :review_id
      t.text :detail
      t.string :exam
      t.integer :medical_case_id

      t.timestamps
    end
  end
end
