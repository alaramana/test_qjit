class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :medical_case_id
      t.boolean :is_active, :default=>false

      t.timestamps
    end
  end
end
