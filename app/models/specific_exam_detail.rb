# == Schema Information
#
# Table name: specific_exam_details
#
#  id              :integer          not null, primary key
#  review_id       :integer
#  detail          :text
#  exam            :string(255)
#  medical_case_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class SpecificExamDetail < ActiveRecord::Base
  attr_accessible :detail, :exam, :medical_case_id, :review_id
  belongs_to :review
  belongs_to :medical_case
end
