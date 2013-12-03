#This is required to make only authorized users  access reports controller actions
class Report
	def self.user_report(filters,sort,page)

		user_q = ""
		user_q << " (lastname ilike '%"+filters.name+"%' or firstname ilike '%"+filters.name+"%' or email ilike '%"+filters.name+"%') and" unless filters.name.nil? or filters.name.empty?
		user_q << " medical_organization_id = "+filters.org_id+" and" unless filters.org_id.nil? or filters.org_id.empty?
		user_q << " (questions_count > 0 and comments_count > 0 and ratings_count > 0)" if !filters.hide_users.nil? and filters.hide_users="yes"
		user_q = user_q.chomp("and")


		exam_questions_count_q =  "(select count(exam_questions.id) from exam_questions where exam_questions.creator_id = users.id and exam_questions.status='approved'"
		exam_questions_count_q << " and exam_questions.objective_id = "+filters.exam_questions_objective_id_in if !filters.exam_questions_objective_id_in.nil? and !filters.exam_questions_objective_id_in.empty?
		exam_questions_count_q << " and exam_questions.created_at >= '"+filters.created_at_gte.to_s+"'" if !filters.created_at_gte.nil?
		exam_questions_count_q << " and exam_questions.created_at <= '"+filters.created_at_lte.to_s+"'" if !filters.created_at_lte.nil?
		exam_questions_count_q << ")"
		
		exam_questions_list_q = ""
		exam_questions_list_q << "select id from exam_questions where objective_id = "+filters.exam_questions_objective_id_in if !filters.exam_questions_objective_id_in.nil? and !filters.exam_questions_objective_id_in.empty?

		comments_count_q =  "(select count(comments.id) from comments where comments.user_id = users.id and commentable_type =  'ExamQuestion'"
		comments_count_q << " and comments.created_at >= '"+filters.created_at_gte.to_s+"'" if !filters.created_at_gte.nil?
		comments_count_q << " and comments.created_at <= '"+filters.created_at_lte.to_s+"'" if !filters.created_at_lte.nil?
		comments_count_q << " and comments.commentable_id in ("+exam_questions_list_q+")" if !filters.exam_questions_objective_id_in.nil? and !filters.exam_questions_objective_id_in.empty?
		comments_count_q << ")"

		ratings_count_q =  "(select count(ratings.id) from ratings where ratings.user_id = users.id"
		ratings_count_q << " and ratings.created_at >= '"+filters.created_at_gte.to_s+"'" if !filters.created_at_gte.nil?
		ratings_count_q << " and ratings.created_at <= '"+filters.created_at_lte.to_s+"'" if !filters.created_at_lte.nil?
		ratings_count_q << " and ratings.exam_question_id in ("+exam_questions_list_q+")" if !filters.exam_questions_objective_id_in.nil? and !filters.exam_questions_objective_id_in.empty?
		ratings_count_q << " and ratings.exam_question_id is not null" if filters.exam_questions_objective_id_in.nil? or filters.exam_questions_objective_id_in.empty?
		ratings_count_q << ")"
		users = User.select("users.id, users.lastname, users.firstname, users.email," \
							+" "+exam_questions_count_q+" as questions_count,"\
							+" "+comments_count_q+" as comments_count,"\
							+" "+ratings_count_q+" as ratings_count "\
							)
					.where(user_q)
					.joins("left outer join exam_questions on (exam_questions.creator_id = users.id)")
					.joins("left outer join comments on (comments.user_id = users.id)")
					.joins("left outer join ratings on (ratings.user_id = users.id)")
					.group("users.id")
					.order(sort.col+" "+sort.dir)
		users = users.page(page.page).per(page.per) if page.paginated
		users
	end
end