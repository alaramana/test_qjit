class CreateOtherStudies < ActiveRecord::Migration
  def change
    create_table :other_studies do |t|
      t.integer :medical_case_id
      t.string :result
      t.string :name

      t.timestamps
    end
  end
end
