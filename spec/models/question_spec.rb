# == Schema Information
#
# Table name: questions
#
#  id                             :integer          not null, primary key
#  medical_case_id                :integer
#  question_prompt                :text
#  correct_answer                 :string(255)
#  correct_answer_explanation     :string(255)
#  incorrect_answer_1             :string(255)
#  incorrect_answer_1_explanation :string(255)
#  incorrect_answer_2             :string(255)
#  incorrect_answer_2_explanation :string(255)
#  incorrect_answer_3             :string(255)
#  incorrect_answer_3_explanation :string(255)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

require 'spec_helper'

describe Question do
	context "Mass assignment" do
		it { should allow_mass_assignment_of(:correct_answer)}
		it { should allow_mass_assignment_of(:correct_answer_explanation)}
		it { should allow_mass_assignment_of(:incorrect_answer_1)}
		it { should allow_mass_assignment_of(:incorrect_answer_1_explanation)}
		it { should allow_mass_assignment_of(:incorrect_answer_2)}
		it { should allow_mass_assignment_of(:incorrect_answer_2_explanation)}
		it { should allow_mass_assignment_of(:incorrect_answer_3_explanation)}
		it { should allow_mass_assignment_of(:incorrect_answer_3)}
		it { should allow_mass_assignment_of(:medical_case_id)}
		it { should allow_mass_assignment_of(:question_prompt)}
	end
  context "Associations" do
		it { should belong_to(:medical_case)}
	end
end
