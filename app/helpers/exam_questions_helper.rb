module ExamQuestionsHelper
	def question_author(question)
		if !question.objective.nil?
			if question.objective.hide_author == true && ["Open", "Pending"].include?(question.objective.status)
				"Hidden"
			else
				question.user.full_name
			end
		else
		 	question.user.full_name
		end
	end

	def question_feedback(question)
		if !question.objective.nil?
			if question.objective.hide_feedback==true && ["Open", "Pending"].include?(question.objective.status)
				"Hidden"
			end
		end
	end
end
