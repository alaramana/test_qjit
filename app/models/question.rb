# == Schema Information
#
# Table name: questions
#
#  id                             :integer          not null, primary key
#  medical_case_id                :integer
#  question_prompt                :text
#  correct_answer                 :string(255)
#  correct_answer_explanation     :string(255)
#  incorrect_answer_1             :string(255)
#  incorrect_answer_1_explanation :string(255)
#  incorrect_answer_2             :string(255)
#  incorrect_answer_2_explanation :string(255)
#  incorrect_answer_3             :string(255)
#  incorrect_answer_3_explanation :string(255)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

class Question < ActiveRecord::Base
  attr_accessible :correct_answer, :correct_answer_explanation, :incorrect_answer_1, :incorrect_answer_1_explanation, :incorrect_answer_2, :incorrect_answer_2_explanation, :incorrect_answer_3_explanation, :incorrect_answer_3, :medical_case_id, :question_prompt
  belongs_to :medical_case
 	# validates_presence_of :correct_answer, :correct_answer_explanation, :incorrect_answer_1, :incorrect_answer_1_explanation, :incorrect_answer_2, :incorrect_answer_2_explanation, :incorrect_answer_3_explanation, :incorrect_answer_3,  :question_prompt
end
