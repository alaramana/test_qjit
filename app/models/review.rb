# == Schema Information
#
# Table name: reviews
#
#  id                        :integer          not null, primary key
#  medical_case_id           :integer
#  temperature               :decimal(, )
#  heart_rate                :decimal(, )
#  blood_pressure            :decimal(, )
#  respiratory_rate          :decimal(, )
#  spo2                      :decimal(, )
#  physical_exam_description :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Review < ActiveRecord::Base
  attr_accessible :blood_pressure, :heart_rate, :medical_case_id, :physical_exam_description, :respiratory_rate, :spo2, :temperature, :specific_exam_details_attributes
  belongs_to :medical_case
  has_many :specific_exam_details
  accepts_nested_attributes_for :specific_exam_details, :allow_destroy => true

end
