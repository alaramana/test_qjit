module BeltExtension
	def update_belt

		if current_user.present? && current_user.active?
			user_submited_questions_count = current_user.exam_questions.count
			user_answers_count = current_user.score_boards.where(:correct=>"true").count
			user_avg_login_count = (current_user.average_session_time/60)

			if  (user_answers_count  > 499 && user_submited_questions_count > 199) or
				(user_submited_questions_count > 199 && user_avg_login_count >99) or
				(user_avg_login_count >99 && user_answers_count  > 499)
				current_user.update_column(:belt, "black")

			elsif  (user_answers_count > 399 && user_submited_questions_count > 99) or
				(user_submited_questions_count > 99 && user_avg_login_count >79) or
				(user_avg_login_count >79 && user_answers_count > 399)
				current_user.update_column(:belt, "brown")


			elsif  (user_answers_count > 299 && user_submited_questions_count > 49 ) or
				(user_submited_questions_count > 49 && user_avg_login_count >59)  or
				(user_avg_login_count >59 && user_answers_count > 299)
				current_user.update_column(:belt, "purple")

			elsif  (user_answers_count > 199 && user_submited_questions_count > 9) or
				(user_submited_questions_count > 9 && user_avg_login_count >39)  or
				(user_avg_login_count >39 && user_answers_count > 199)
				current_user.update_column(:belt, "red")

			elsif  (user_answers_count > 99 && user_submited_questions_count > 4) or
				(user_submited_questions_count > 4 && user_avg_login_count >19) or
				(user_avg_login_count >19 && user_answers_count > 99)
				current_user.update_column(:belt, "blue")

			else
				current_user.update_column(:belt, "white")

			end
		end
	end
end