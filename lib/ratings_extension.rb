module RatingsExtension
	def rated_by?(userId)
		!select{|r| r.user_id==userId}.empty?
	end
	def rating_for_user(userId)
		select{|r| r.user_id==userId}.first
	end
end