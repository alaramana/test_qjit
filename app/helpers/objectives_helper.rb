module ObjectivesHelper
	def can_start_date_edit(objective)
		unless objective.status == "Closed"
			if objective.exam_questions.count == 0 && objective.start_date.in_time_zone < Time.now.in_time_zone
				return true
			elsif objective.exam_questions.count != 0 && objective.start_date.in_time_zone > Time.now.in_time_zone
				return true
			elsif objective.status == "Pending"
				return true
			else
				return false
			end
		else
			return false
		end
	end	 
end
