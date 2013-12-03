# == Schema Information
#
# Table name: medical_histories
#
#  id                   :integer          not null, primary key
#  medical_case_id      :integer
#  medication           :text
#  allergies            :text
#  past_medical_history :text
#  family_history       :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class MedicalHistory < ActiveRecord::Base
  attr_accessible :allergies, :family_history, :medical_case_id, :medication, :past_medical_history
  belongs_to :medical_case
end
