class UpdateTotalRatingsCountToExamQuestions < ActiveRecord::Migration
	def up
		# Set total rating value for default
		ExamQuestion.where(:total_ratings=>nil).update_all(:total_ratings=>0.0)
		# calculate the value of each
		rating = Rating.select('exam_question_id, rate').group_by(&:exam_question)
		if rating.present?
			rating.each do |mcase, rates|
				total= rates.collect(&:rate)
				avg = total.sum.to_f/total.count
				if !mcase.nil?
					mcase.update_column(:total_ratings, total.count)
					mcase.update_column(:average_rating, avg.to_f)
				end
			end
		end
	end

	def down
	end
end
