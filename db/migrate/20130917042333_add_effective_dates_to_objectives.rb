class AddEffectiveDatesToObjectives < ActiveRecord::Migration
  def change
	add_column :objectives, :start_date, :date
	add_column :objectives, :end_date, :date
  end
end
