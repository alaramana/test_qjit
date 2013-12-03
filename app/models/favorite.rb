# == Schema Information
#
# Table name: favorites
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  medical_case_id  :integer
#  is_active        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exam_question_id :integer
#

class Favorite < ActiveRecord::Base
  attr_accessible :is_active, :medical_case_id, :user_id, :exam_question_id
  belongs_to :user
  belongs_to :medical_case
  belongs_to :exam_question
end
