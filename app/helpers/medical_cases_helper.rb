module MedicalCasesHelper

	def form_build
		@medical_case.build_medical_history if @medical_case.medical_history.nil?
		@medical_case.build_review if @medical_case.review.nil?
		@medical_case.review.specific_exam_details if @medical_case.review.specific_exam_details.nil?
		@medical_case.labs.build if @medical_case.labs.nil?
		@medical_case.imagings.build if @medical_case.imagings.nil?
		@medical_case.other_studies.build if @medical_case.other_studies.nil?
		@medical_case.build_question if @medical_case.question.nil?
	end

	def new_form
		@medical_case.build_medical_history
		@medical_case.build_review
		@medical_case.review.specific_exam_details.build
		@medical_case.labs.build
		@medical_case.imagings.build
		@medical_case.other_studies.build
		@medical_case.build_question
	end

	def score_count(exam_mode)
		if exam_mode =="sparring_mode"
			current_user.score_boards.where(:exam_mode=>exam_mode, :correct=>true, :status=>"incomplete").collect(&:correct).size
		elsif exam_mode =="exam_mode"
			answers= current_user.score_boards.where(:exam_mode=>exam_mode,:status=>"incomplete").collect(&:correct)
			if answers.include?(false)
				0
			else
				answers.size
			end
		end
	end


	def level(score)
		case score
		when 0..10 then  "Grass Hopper"
		when 11..20 then "Fists of Fury"
		when 21..40 then "Enter the Dragon"
		when 40..1000 then "Grand Master"
		end
	end

	def total_time_taken
		answers= current_user.score_boards.where(:exam_mode=>"exam_mode",:status=>"incomplete").collect(&:time_taken)
		time = answers.map{|x| x.to_i}.sum

		hours = time/3600.to_i
		minutes = (time/60 - hours * 60).to_i
		seconds = (time - (minutes * 60 + hours * 3600))

		"#{'%02d' % minutes} : #{'%02d' % seconds}"
	end

end
