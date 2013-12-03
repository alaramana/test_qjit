class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :medical_case_id
      t.decimal :temperature
      t.decimal :heart_rate
      t.decimal :blood_pressure
      t.decimal :respiratory_rate
      t.decimal :spo2
      t.text :physical_exam_description

      t.timestamps
    end
  end
end
