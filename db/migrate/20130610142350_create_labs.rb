class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.integer :medical_case_id
      t.string :result
      t.string :name

      t.timestamps
    end
  end
end
