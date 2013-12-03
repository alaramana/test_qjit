# == Schema Information
#
# Table name: exam_questions
#
#  id                         :integer          not null, primary key
#  question_prompt            :text
#  objective_id               :integer
#  creator_id                 :integer
#  educational_purpose        :text
#  medical_case_id            :integer
#  correct_answer             :string(255)
#  correct_answer_explanation :string(255)
#  incorrect_1                :string(255)
#  incorrect_1_explanation    :string(255)
#  status                     :string(255)      default("approved")
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  average_rating             :decimal(, )      default(0.0), not null
#  photo_file_name            :string(255)
#  photo_content_type         :string(255)
#  photo_file_size            :integer
#  photo_updated_at           :datetime
#

require 'spec_helper'

describe ExamQuestion do
	include UserHelper
	context "Mass assignment" do
		it { should allow_mass_assignment_of(:objective_id)                      }
		it { should allow_mass_assignment_of(:question_prompt) 				           }
		it { should allow_mass_assignment_of(:educational_purpose) 		           }
		it { should allow_mass_assignment_of(:medical_case_id) 				           }
		it { should allow_mass_assignment_of(:correct_answer) 			             }
		it { should allow_mass_assignment_of(:correct_answer_explanation) 	     }
		it { should allow_mass_assignment_of(:incorrect_1) 				               }
		it { should allow_mass_assignment_of(:incorrect_1_explanation)           }
		it { should allow_mass_assignment_of(:tag_list) 				                 }
	end


	context "Nested Attributes" do
		it { should accept_nested_attributes_for(:incorrect_answers)  					 }
	end

	context "Validations" do
		it { should validate_presence_of(:question_prompt)                       }
		it { should validate_uniqueness_of(:question_prompt)                     }
	end

	context "Associations" do
		it { should belong_to(:user).with_foreign_key(:creator_id)                }
		it { should belong_to(:objective)                                         }
		it { should belong_to(:medical_case)                                      }
		it { should have_many(:incorrect_answers)                                 }
		it { should have_many(:favorites)                                         }
		it { should have_many(:rating)                                            }
	end



	describe ".list" do
		before do
			@objective = Fabricate(:objective)
			@exam_question = Fabricate(:exam_question,:objective_id =>@objective.id)
			@user = create_admin_with_invitation
		end
		context"should sort exam questions" do
			it "should list of exam questions" do
				ExamQuestion.list(@user, {:order=>"created_at"}).should_not be_nil
			end

			it "should list of exam questions" do
				ExamQuestion.list(@user, {:order=>"author"}).should_not be_nil
			end

			it "should list of exam questions" do
				ExamQuestion.list(@user, {:order=>"personal"}).should_not be_nil
			end


			it "should list of exam questions" do
				ExamQuestion.list(@user, {:order=>"average"}).should_not be_nil
			end

			it "should list of exam questions" do
				ExamQuestion.list(@user, {:order=>"review"}).should_not be_nil
			end

			it "should list of exam questions" do
				ExamQuestion.list(@user, {:order=>""}).should_not be_nil
			end
		end

		context "should query the database" do
			it "should list exam questions with given question prompt title" do
				objective = Fabricate(:objective)
				exam_question = Fabricate(:exam_question,:question_prompt=>"voyage",:objective_id =>objective.id)
				user = create_admin_with_invitation
				ExamQuestion.list(user, {:query=>{"question_prompt_contains"=>"vo"}, :order=>"average"}).should_not be_nil
			end


			it "should list favorite exam questions" do
				objective = Fabricate(:objective)
				exam_question = Fabricate(:exam_question,:objective_id =>objective.id)
				user = create_admin_with_invitation
				favorite = Fabricate(:favorite,:exam_question_id=>exam_question.id,:is_active => true)
				ExamQuestion.list(user, {:query=>{"favorites_is_active_is_true"=>"yes"}, :order=>"average"}).should_not be_nil
			end

			it "should list of exam questions" do
				objective = Fabricate(:objective)
				exam_question = Fabricate(:exam_question,:question_prompt=>"voyage",:objective_id =>objective.id)
				user = create_admin_with_invitation
				ExamQuestion.list(user, {:query=>{"question_prompt_contains"=>"vo",}, :order=>"average", :not_answer=>"1"}).should_not be_nil
			end


			it "should list exam questions with average_rating_greater_than the given value" do
				objective = Fabricate(:objective)
				exam_question = Fabricate(:exam_question,:objective_id =>objective.id)
				user = create_admin_with_invitation
				rating = Fabricate(:rating, :rate=>"5",:exam_question_id =>exam_question.id,:user_id =>user.id )
				ExamQuestion.list(user, {:query=>{ "average_rating_greater_than"=>"3"}, :order=>"created_at"}).should_not be_nil
			end


			it "should list exam questions with current user rating greater than with the given value" do
				objective = Fabricate(:objective)
				exam_question = Fabricate(:exam_question,:objective_id =>objective.id)
				user = create_admin_with_invitation
				rating = Fabricate(:rating, :rate=>"5",:exam_question_id =>exam_question.id,:user_id =>user.id )
				ExamQuestion.list(user, {:query=>{ "ratings_rate_greater_than"=>"3"}, :order=>"created_at"}).should_not be_nil
			end


			it "should list all exam question created by the given author" do
				objective = Fabricate(:objective)
				user = create_admin_with_invitation
				user.firstname = "dave"
				user.save
				medical_case = Fabricate(:medical_case)
				exam_question = Fabricate(:exam_question,:objective_id =>objective.id,:medical_case_id=>medical_case.id,:creator_id=>user.id)
				ExamQuestion.list(user, { :query=>{"user_firstname_contains"=>"dave"}}).should_not be_nil
			end


			it "should list  exam questions with the given objective name" do
				objective = Fabricate(:objective,:name=>"back-pain")
				user = create_admin_with_invitation
				medical_case = Fabricate(:medical_case)
				exam_question = Fabricate(:exam_question,:objective_id =>objective.id,:medical_case_id=>medical_case.id,:creator_id=>user.id)
				ExamQuestion.list(user, {:query=>{"objective_name_contains"=>"1"}, :order=>"average"}).should_not be_nil
			end


			it "should list exam questions with the given tag" do
				objective = Fabricate(:objective)
				user = create_admin_with_invitation
				medical_case = Fabricate(:medical_case)
				exam_question = Fabricate(:exam_question,:objective_id =>objective.id,:medical_case_id=>medical_case.id,:tag_list=>"one,test")
				ExamQuestion.list(user, {:order=>"average", :tag_name=>"one"}).should_not be_nil
			end

			it "should list incorrect and not answered exam questions answered by current user" do
				objective = Fabricate(:objective)
				user = create_admin_with_invitation
				medical_case = Fabricate(:medical_case)
				exam_question = Fabricate(:exam_question,:objective_id =>objective.id,:medical_case_id=>medical_case.id)
				Fabricate(:score_board ,:correct => false,:exam_question_id => exam_question.id,:medical_case_id=>medical_case.id)
				ExamQuestion.list(user, {:query=>{"score_boards_correct_is_false"=>"1"}, :order=>"average", :not_answer=>"1"}).should_not be_nil
			end

			it "should list incorrect exam questions answered by current user" do
				objective = Fabricate(:objective)
				user = create_admin_with_invitation
				medical_case = Fabricate(:medical_case)
				exam_question = Fabricate(:exam_question,:objective_id =>objective.id,:medical_case_id=>medical_case.id)
				Fabricate(:score_board ,:correct => false,:exam_question_id => exam_question.id,:medical_case_id=>medical_case.id)
				ExamQuestion.list(user, {:query=>{"score_boards_correct_is_false"=>"1"}}).should_not be_nil
			end
		end
	end
	context ".sparring" do
		it "should rcheck the sparring mode exam" do
			objective = Fabricate(:objective)
			user = create_admin_with_invitation
			medical_case = Fabricate(:medical_case)
			exam_question = Fabricate(:exam_question,:objective_id =>objective.id,:medical_case_id=>medical_case.id)
			ExamQuestion.sparring(user, {:step=>"1", :mcase=>medical_case.id, :question=>exam_question.id, :order=>"average"}).should_not be_nil
		end
	end
	context ".exam" do
		it "should rcheck the exam mode exam" do
			objective = Fabricate(:objective)
			user = create_admin_with_invitation
			medical_case = Fabricate(:medical_case)
			exam_question = Fabricate(:exam_question,:objective_id =>objective.id,:medical_case_id=>medical_case.id)
			ExamQuestion.exam(user, {:step=>"1", :mcase=>medical_case.id, :question=>exam_question.id}).should_not be_nil
		end
	end
end
