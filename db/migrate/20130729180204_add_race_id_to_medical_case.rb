class AddRaceIdToMedicalCase < ActiveRecord::Migration
  def change
    add_column :medical_cases, :race_id, :integer
  end
end
