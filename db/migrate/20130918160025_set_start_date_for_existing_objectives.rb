class SetStartDateForExistingObjectives < ActiveRecord::Migration
  def up
	  objectives = Objective.find(:all)
	  objectives.each do |o|
		  if o.start_date.nil?
		  	o.start_date=o.created_at.to_date()
			o.save(validate: false)
		  end
  	 end
  end

  def down
  end
end
