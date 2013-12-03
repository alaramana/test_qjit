namespace :db do
	desc "Erase and fill database"
	task :populate => :environment do
		require 'populator'
		require 'ffaker'

		# MedicalOrganization.populate 50 do |mo|
		# 	mo.name =  Faker::Company.name
		# 	mo.status = true
		# end

		medical_cases =[]

		MedicalCase.populate 50 do |mc|
			mc.title = Faker::Company.name
			mc.age = (10..60).to_a.sample
			mc.average_rating = (1..5).to_a.sample
			mc.creator_id=1
			mc.status="approved"

			Review.populate 1 do |review|
				review.blood_pressure = (10..60).to_a.sample
				review.heart_rate = (10..60).to_a.sample
				review.respiratory_rate = (10..60).to_a.sample
				review.spo2 = (10..60).to_a.sample
				review.temperature = (10..60).to_a.sample
				review.physical_exam_description =Faker::Lorem.paragraph()
				review.medical_case_id= mc.id

				SpecificExamDetail.populate 1 do |sed|
					sed.exam = Faker::Internet.user_name
					sed.review_id=  review.id
					sed.medical_case_id= mc.id
				end
			end
			MedicalHistory.populate 60 do |mh|
				mh.allergies=Faker::Lorem.paragraph()
				mh.family_history=Faker::Lorem.paragraph()
				mh.medical_case_id= mc.id
				mh.medication=Faker::Lorem.paragraph()
				mh.past_medical_history=Faker::Lorem.paragraph()
			end

			Lab.populate 3 do |l|
				l.medical_case_id = mc.id
				l.result =["pass","fails"].sample(2)
				l.name =Faker::Name.name
			end
			Imaging.populate 3 do |l|
				l.medical_case_id = mc.id
				l.result =["pass","fails"].sample(2)
				l.name =Faker::Name.name
			end
			OtherStudy.populate 3 do |l|
				l.medical_case_id = mc.id
				l.result =["pass","fails"].sample(2)
				l.name =Faker::Name.name
			end

			Question.populate 1 do |q|
				q.correct_answer=Faker::Name.name
				q.correct_answer_explanation=Faker::Lorem.sentences()
				q.incorrect_answer_1=Faker::Name.name
				q.incorrect_answer_1_explanation=Faker::Lorem.sentences()
				q.incorrect_answer_2=Faker::Name.name
				q.incorrect_answer_2_explanation=Faker::Lorem.sentences()
				q.incorrect_answer_3_explanation=Faker::Lorem.sentences()
				q.incorrect_answer_3=Faker::Name.name
				q.medical_case_id= mc.id
				q.question_prompt=Faker::Lorem.sentences()
			end
			medical_cases << mc.id
		end
		ExamQuestion.populate 50 do |q|
			pos = []
			pos << [1,3,4,0,2]
			q.question_prompt = Faker::Lorem.paragraph()
			q.creator_id = 1
			q.objective_id = 1
			q.educational_purpose = Faker::Lorem.paragraph()
			q.medical_case_id = medical_cases.sample
			q.correct_answer = Faker::Name.name
			q.correct_answer_explanation =Faker::Lorem.sentences()
			q.incorrect_1 =  Faker::Name.name
			q.incorrect_1_explanation = Faker::Lorem.sentences()
			q.status ="approved"
			q.average_rating = [1,2,3,4,5].sample
			q.total_ratings = 1
			q.position = pos

			IncorrectAnswer.populate 3 do |ic|
				ic.answer = Faker::Name.name
				ic.exam_question_id = q.id
				ic.explanation = Faker::Lorem.sentences()
			end

		end

	end
end

