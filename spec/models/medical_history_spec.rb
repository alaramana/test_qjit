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

require 'spec_helper'

describe MedicalHistory do
  context "Mass assignment" do
		it { should allow_mass_assignment_of(:allergies)}
		it { should allow_mass_assignment_of(:family_history)}
		it { should allow_mass_assignment_of(:medical_case_id)}
		it { should allow_mass_assignment_of(:medication)}
		it { should allow_mass_assignment_of(:past_medical_history)}
	end
	context "Associations" do
		it { should belong_to(:medical_case)}
	end
end
