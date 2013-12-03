class AddColumnMedicalOrganizationToObjectives < ActiveRecord::Migration
  def up
    add_column :objectives, :medical_organization_id, :integer
    Objective.update_all :medical_organization_id=> 1
  end

  def down
  	remove_column :objectives, :medical_organization_id
  end
end
