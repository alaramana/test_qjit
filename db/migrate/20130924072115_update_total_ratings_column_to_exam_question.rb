class UpdateTotalRatingsColumnToExamQuestion < ActiveRecord::Migration
	def up
		ExamQuestion.all.each do |rate|
			if rate.average_rating > 0
				rate.total_ratings = rate.average_rating
				rate.save
			end
		end
	end

	def down
	end
end
