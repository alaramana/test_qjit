# == Schema Information
#
# Table name: other_studies
#
#  id              :integer          not null, primary key
#  medical_case_id :integer
#  result          :string(255)
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class OtherStudy < ActiveRecord::Base
  attr_accessible :medical_case_id, :result, :name
  belongs_to :medical_case
end
