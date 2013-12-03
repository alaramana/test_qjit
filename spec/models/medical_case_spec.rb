# == Schema Information
#
# Table name: medical_cases
#
#  id                         :integer          not null, primary key
#  title                      :string(255)
#  age                        :integer
#  gender                     :string(255)
#  race_id                    :integer
#  chief_complaint            :text
#  history_of_present_illness :text
#  creator_id                 :integer
#  status                     :string(255)
#  educational_race      :text
#  average_rating             :decimal(, )      default(0.0), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

require 'spec_helper'

describe MedicalCase do
	include UserHelper

	context "Mass assignment" do
		it { should allow_mass_assignment_of(:title)                             }
		it { should allow_mass_assignment_of(:age) 				                       }
		it { should allow_mass_assignment_of(:gender) 				                   }
		it { should allow_mass_assignment_of(:race) 				                     }
		it { should allow_mass_assignment_of(:chief_complaint) 			             }
		it { should allow_mass_assignment_of(:history_of_present_illness) 	     }
		it { should allow_mass_assignment_of(:creator_id) 				               }
		it { should allow_mass_assignment_of(:status) 				                   }
		# it { should allow_mass_assignment_of(:educational_race) 				     }
		it { should allow_mass_assignment_of(:average_rating) 				           }
		it { should allow_mass_assignment_of(:tag_list) 				                 }

		it { should allow_mass_assignment_of(:medical_history_attributes) 				}
		it { should allow_mass_assignment_of(:review_attributes) 				          }
		it { should allow_mass_assignment_of(:labs_attributes) 				            }
		it { should allow_mass_assignment_of(:imagings_attributes) 				        }
		it { should allow_mass_assignment_of(:other_studies_attributes) 				  }
		it { should allow_mass_assignment_of(:question_attributes) 				        }

	end


	context "Nested Attributes" do
		it { should accept_nested_attributes_for(:review) }
		it { should accept_nested_attributes_for(:medical_history) }
		it { should accept_nested_attributes_for(:labs) }
		it { should accept_nested_attributes_for(:imagings) }
		it { should accept_nested_attributes_for(:other_studies) }
		it { should accept_nested_attributes_for(:question) }
	end

	context "Validations" do
		it { should validate_presence_of(:title)                                 }
		it { should validate_uniqueness_of(:title)                               }
		it { should validate_presence_of(:age)                                   }
		it { should validate_numericality_of(:age).only_integer                  }
	end

	context "Associations" do
		it { should belong_to(:user).with_foreign_key(:creator_id)                }

		it { should have_one(:review)                                             }
		it { should have_one(:medical_history)                                    }
		it { should have_one(:question)                                           }

		it { should have_many(:labs)                                              }
		it { should have_many(:imagings)                                              }
		it { should have_many(:other_studies)                                              }
		it { should have_many(:favorites)                                              }
		it { should have_many(:rating)                                              }

	end

	describe ".list" do
		before do
			@race = Fabricate(:race)
			@medical_case = Fabricate(:medical_case,:race_id =>@race.id)
			@user = create_admin_with_invitation
		end
		context"should sort medical cases" do
			it "should list of medical cases" do
				MedicalCase.list(@user, {:order=>"created_at"}).should_not be_nil
			end

			it "should list of medical cases" do
				MedicalCase.list(@user, {:order=>"author"}).should_not be_nil
			end

			it "should list of medical cases" do
				MedicalCase.list(@user, {:order=>"personal"}).should_not be_nil
			end


			it "should list of medical cases" do
				MedicalCase.list(@user, {:order=>"average"}).should_not be_nil
			end

			it "should list of medical cases" do
				MedicalCase.list(@user, {:order=>""}).should_not be_nil
			end
		end

		context "should query the database" do
			it "should list medical cases with given question prompt title" do
				race = Fabricate(:race)
				medical_case = Fabricate(:medical_case,:title=>"voyage",:race_id =>race.id)
				user = create_admin_with_invitation
				MedicalCase.list(user, {:query=>{"title_contains"=>"vo"}, :order=>"average"}).should_not be_nil
			end


			it "should list favorite medical cases" do
				race = Fabricate(:race)
				medical_case = Fabricate(:medical_case,:race_id =>race.id)
				user = create_admin_with_invitation
				favorite = Fabricate(:favorite,:medical_case_id=>medical_case.id,:is_active => true)
				MedicalCase.list(user, {:query=>{"favorites_is_active_is_true"=>"yes"}, :order=>"average"}).should_not be_nil
			end

			# it "should list of medical cases" do
			# 	race = Fabricate(:race)
			# 	medical_case = Fabricate(:medical_case,:title=>"voyage",:race_id =>race.id)
			# 	user = create_admin_with_invitation
			# 	MedicalCase.list(user, {:query=>{"title_contains"=>"vo",}, :order=>"average", :not_answer=>"1"}).should_not be_nil
			# end


			it "should list medical cases with average_rating_greater_than the given value" do
				race = Fabricate(:race)
				medical_case = Fabricate(:medical_case,:race_id =>race.id)
				user = create_admin_with_invitation
				rating = Fabricate(:rating, :rate=>"5",:medical_case_id =>medical_case.id,:user_id =>user.id )
				MedicalCase.list(user, {:query=>{ "average_rating_greater_than"=>"3"}, :order=>"created_at"}).should_not be_nil
			end


			it "should list medical cases with current user rating greater than with the given value" do
				race = Fabricate(:race)
				medical_case = Fabricate(:medical_case,:race_id =>race.id)
				user = create_admin_with_invitation
				rating = Fabricate(:rating, :rate=>"5",:medical_case_id =>medical_case.id,:user_id =>user.id )
				MedicalCase.list(user, {:query=>{ "ratings_rate_greater_than"=>"3"}, :order=>"created_at"}).should_not be_nil
			end


			it "should list all exam question created by the given author" do
				race = Fabricate(:race)
				user = create_admin_with_invitation
				user.firstname = "dave"
				user.save
				medical_case = Fabricate(:medical_case,:race_id =>race.id,:creator_id=>user.id)
				MedicalCase.list(user, { :query=>{"user_firstname_contains"=>"dave"}, :order=>"average"}).should_not be_nil
			end


			it "should list  medical cases with the given race name" do
				race = Fabricate(:race,:name=>"white-american")
				user = create_admin_with_invitation
				medical_case = Fabricate(:medical_case,:race_id =>race.id,:creator_id=>user.id)
				MedicalCase.list(user, {:query=>{"race_name_contains"=>"1"}, :order=>"average"}).should_not be_nil
			end


			it "should list medical cases with the given tag" do
				race = Fabricate(:race)
				user = create_admin_with_invitation
				medical_case = Fabricate(:medical_case,:race_id =>race.id,:tag_list=>"one,test")
				MedicalCase.list(user, {:order=>"average", :tag_name=>",one"}).should_not be_nil
			end

			# it "should list incorrect and not answered medical cases answered by current user" do
			# 	race = Fabricate(:race)
			# 	user = create_admin_with_invitation
			# 	medical_case = Fabricate(:medical_case,:race_id =>race.id)
			# 	Fabricate(:score_board ,:correct => false,:medical_case_id => medical_case.id,:medical_case_id=>medical_case.id)
			# 	MedicalCase.list(user, {:query=>{"score_boards_correct_is_false"=>"1"}, :order=>"average", :not_answer=>"1"}).should_not be_nil
			# end

			it "should list incorrect medical cases answered by current user" do
				race = Fabricate(:race)
				user = create_admin_with_invitation
				medical_case = Fabricate(:medical_case,:race_id =>race.id)
				Fabricate(:score_board ,:correct => false,:medical_case_id => medical_case.id,:medical_case_id=>medical_case.id)
				MedicalCase.list(user, {:query=>{"score_boards_correct_is_false"=>"1"}}).should_not be_nil
			end
		end
	end

	# context ".approved_medical_cases" do
	# 	before do
	# 		Fabricate(:medical_case,:status =>"approved")
	# 	end
	# 	it "should list only approved medical cases" do
	# 		MedicalCase.approved_medical_cases
	# 	end
	# end

	context ".all_models" do
		before do
			Fabricate(:rating)
			invite = Fabricate(:invite,:role_id=>2)
			Fabricate(:user,:email =>invite.email,:role_id=>invite.role_id)
			Fabricate(:favorite)
			Fabricate(:score_board)
		end
		it "should query all all models" do
			MedicalCase.all_models
		end
	end
end
