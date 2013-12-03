class ChangeStatusToSuspendedOnObjectives < ActiveRecord::Migration
  def up
	rename_column :objectives, :status, :suspended

	Objective.reset_column_information
	objectives = Objective.find(:all)
	objectives.each do |o|
		o.suspended = !o.suspended
		o.save
	end
  end
end
