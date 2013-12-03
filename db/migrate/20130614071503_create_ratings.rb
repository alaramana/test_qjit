class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :medical_case_id
      t.decimal :rate, :null => false, :default => 0

      t.timestamps
    end
  end
end
