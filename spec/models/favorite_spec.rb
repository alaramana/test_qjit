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

require 'spec_helper'

describe Favorite do

	context "Mass assignment" do
		it { should allow_mass_assignment_of(:medical_case_id)}
		it { should allow_mass_assignment_of(:is_active)}
		it { should allow_mass_assignment_of(:user_id)}
	end
	context "Associations" do
		it { should belong_to(:user)}
		it { should belong_to(:medical_case)}
	end
end
