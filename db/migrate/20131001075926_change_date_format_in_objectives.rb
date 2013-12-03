class ChangeDateFormatInObjectives < ActiveRecord::Migration
	def self.up
		change_column :objectives, :start_date, :datetime
		change_column :objectives, :end_date, :datetime
	end

	def self.down
		change_column :objectives, :start_date, :date
		change_column :objectives, :end_date, :date
	end
end
