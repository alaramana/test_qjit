# == Schema Information
#
# Table name: score_boards
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  medical_case_id  :integer
#  correct          :boolean
#  status           :string(255)
#  answer           :string(255)
#  time_taken       :string(255)
#  exam_mode        :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exam_number      :integer          default(1), not null
#  attempt          :integer          default(1), not null
#  exam_question_id :integer
#

class ScoreBoard < ActiveRecord::Base
	attr_accessible :batch, :medical_case_id, :correct, :status, :time_taken, :exam_mode,:exam_number, :answer,:user_id, :attempt, :exam_question_id

	belongs_to :user
	belongs_to :medical_case
	belongs_to :exam_question

	before_create :set_status
	before_update :update_question_attempt

	def update_question_attempt
		self.attempt = self.attempt.to_i + 1
	end

	def set_status
		self.status = "incomplete"
	end

	class << self

		def exam_question_result(current_user, options={})
			exam_question, medical_case,  score_board = options[:exam_question], options[:medical_case], options[:score_board]
			question 					= ExamQuestion.find(exam_question)
			score 						= question.score_boards.new(score_board)
			score.correct 		= check_correct_answer(question, score)    #checking correct answer below method
			score.user_id 		= current_user.id
			score.exam_number = set_exam_number(current_user, score) #setting exam number below method
			score
		end

		def set_exam_number(current_user, score)
			prev = current_user.score_boards.where(:exam_mode=>score.exam_mode)
			sc = ScoreBoard.last
			if !sc.nil?
				if !prev.empty?
					if prev.last.status == "incomplete"
						score.exam_number = prev.last.exam_number
					else
						score.exam_number = prev.last.exam_number + 1
					end
				else
					score.exam_number = 1
				end
			else
				score.exam_number = 1
			end
		end

		def check_correct_answer(question, score)
			question.correct_answer == score.answer
		end


		def sparring_records(options={})
			# raise options.inspect
			id, score_board, exam_question, medical_case = options[:score_id], options[:score_board] ,options[:exam_question],options[:medical_case]
			question  = ExamQuestion.find(exam_question)
			score 		= question.score_boards.find(id)
			score.update_attributes(score_board)
			score.update_column(:correct,check_correct_answer(question, score))
			score
		end

	end


end
