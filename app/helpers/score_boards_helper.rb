module ScoreBoardsHelper
	def score_board_incomplete
		current_user.score_boards.where(:exam_mode=>"exam_mode", :status=>"incomplete").present?
	end
end
