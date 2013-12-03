class CreateMedicalHistories < ActiveRecord::Migration
  def change
    create_table :medical_histories do |t|
      t.integer :medical_case_id
      t.text :medication
      t.text :allergies
      t.text :past_medical_history
      t.text :family_history

      t.timestamps
    end
  end
end
