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

require 'spec_helper'

describe Review do
  context "Mass assignment" do
		it { should allow_mass_assignment_of(:blood_pressure)}
		it { should allow_mass_assignment_of(:heart_rate)}
		it { should allow_mass_assignment_of(:medical_case_id)}
		it { should allow_mass_assignment_of(:physical_exam_description)}
		it { should allow_mass_assignment_of(:respiratory_rate)}
		it { should allow_mass_assignment_of(:spo2)}
		it { should allow_mass_assignment_of(:temperature)}
		it { should allow_mass_assignment_of(:specific_exam_details_attributes)}
	end
	context "Nested Attributes" do
		it { should accept_nested_attributes_for(:specific_exam_details) }
	end
	context "Associations" do
		it { should belong_to(:medical_case)}
		it { should have_many(:specific_exam_details)}
	end
end
