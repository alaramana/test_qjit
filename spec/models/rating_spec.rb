# == Schema Information
#
# Table name: ratings
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  medical_case_id  :integer
#  rate             :decimal(, )      default(0.0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exam_question_id :integer
#

require 'spec_helper'

describe Rating do
	context "Mass assignment" do
		it { should allow_mass_assignment_of(:medical_case_id)                     }
		it { should allow_mass_assignment_of(:rate) 				                       }
		it { should allow_mass_assignment_of(:user_id) 				                     }
	end

	context "Associations" do
		it { should belong_to(:user)}
		it { should belong_to(:medical_case)}
	end


	describe ".calculate_case_average" do
		before do
			5.times  do
				@medical_case = Fabricate(:medical_case,:average_rating=>(1..5).to_a.sample)
				@rating = Fabricate(:rating,:medical_case_id=>@medical_case.id)
				# total = @medical_case.average_rating
				# @medical_case.update_column("average_rating",total/5)
			end
		end
		it 'should show average ratings' do
			Rating.calculate_case_average.should_not be_empty
		end
	end

	describe ".calculate_question_average" do
		before do
			5.times  do
				@exam_question = Fabricate(:exam_question,:average_rating=>(1..5).to_a.sample)
				@rating = Fabricate(:rating,:exam_question_id=>@exam_question.id)
			end
		end
		it 'should show average ratings' do
			Rating.calculate_question_average.should_not be_empty
		end
	end
end

