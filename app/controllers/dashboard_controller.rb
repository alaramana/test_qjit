class DashboardController < ApplicationController
  before_filter :authenticate_user!

	def index
		@questions = current_user.exam_questions.order("created_at desc").limit(5)
		# Fix this, obviously, once objectives are assigned to organizations!
		@assignments = Objective.where(:medical_organization_id =>current_user.medical_organization_id).order("end_date desc").all()

	end

end
