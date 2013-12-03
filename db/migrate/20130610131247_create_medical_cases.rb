class CreateMedicalCases < ActiveRecord::Migration
  def change
    create_table :medical_cases do |t|
      t.string :title
      t.integer :age
      t.string :gender
      t.text :chief_complaint
      t.text :history_of_present_illness
      t.integer :creator_id
      t.string :status
      t.text :educational_objective
      t.decimal :average_rating, :null => false, :default => 0
      t.timestamps
    end
  end
end
