# == Schema Information
#
# Table name: incorrect_answers
#
#  id               :integer          not null, primary key
#  exam_question_id :integer
#  answer           :string(255)
#  explanation      :string(255)
#  seqence          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe IncorrectAnswer do
  
  context "mass-assignment" do
  	it { should allow_mass_assignment_of(:answer)}
  	it { should allow_mass_assignment_of(:exam_question_id)}
  	it { should allow_mass_assignment_of(:explanation)}
  	it { should allow_mass_assignment_of(:seqence)}
  end

  context "Associations" do
  	it { should belong_to(:exam_question)}
  end
end
