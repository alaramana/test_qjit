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

require 'spec_helper'

describe SpecificExamDetail do
 context "Mass assignment" do
		it { should allow_mass_assignment_of(:detail)}
		it { should allow_mass_assignment_of(:exam)}
		it { should allow_mass_assignment_of(:medical_case_id)}
		it { should allow_mass_assignment_of(:review_id)}
	end
	context "Associations" do
		it { should belong_to(:review)}
		it { should belong_to(:medical_case)}
	end
end
