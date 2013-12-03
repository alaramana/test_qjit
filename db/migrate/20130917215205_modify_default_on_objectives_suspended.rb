class ModifyDefaultOnObjectivesSuspended < ActiveRecord::Migration
  def up
	  change_column_default(:objectives, :suspended, false)
  end

  def down
	  change_column_default(:objectives, :suspended, true)
  end
end
