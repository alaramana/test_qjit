# == Schema Information
#
# Table name: ratings
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  medical_case_id  :integer
#  rate             :decimal(, )      default(0.0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exam_question_id :integer
#

class Rating < ActiveRecord::Base
	attr_accessible :medical_case_id, :rate, :user_id, :exam_question_id

	belongs_to :medical_case
	belongs_to :user
	belongs_to :exam_question


	def self.calculate_case_average
		rating = Rating.select('medical_case_id, rate').group_by(&:medical_case)

		unless rating.empty?
			rating.each do |mcase, rates|
				total= rates.collect(&:rate)
				avg = total.sum.to_f/total.count
				if !mcase.nil?
					mcase.update_column(:average_rating, avg.to_f)
				end
			end
		end
	end

	def self.calculate_question_average
		rating = Rating.select('exam_question_id, rate').group_by(&:exam_question)

		unless rating.empty?
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


end
