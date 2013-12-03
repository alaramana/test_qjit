# == Schema Information
#
# Table name: incorrect_answers
#
#  id               :integer          not null, primary key
#  exam_question_id :integer
#  answer           :string(255)
#  explanation      :string(255)
#  seqence          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class IncorrectAnswer < ActiveRecord::Base
  attr_accessible :answer, :exam_question_id, :explanation, :seqence
  belongs_to :exam_question
end
