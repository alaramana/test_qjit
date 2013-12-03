# == Schema Information
#
# Table name: labs
#
#  id              :integer          not null, primary key
#  medical_case_id :integer
#  result          :string(255)
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Lab do
	context "Mass assignment" do
		it { should allow_mass_assignment_of(:medical_case_id)}
		it { should allow_mass_assignment_of(:result)}
		it { should allow_mass_assignment_of(:name)}
	end
	context "Associations" do
		it { should belong_to(:medical_case)}
	end
end
