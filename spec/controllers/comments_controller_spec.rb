require 'spec_helper'

describe CommentsController do

	shared_examples_for "users_comments" do
		before do
			sign_in :user, logged_in_user
		end
		describe "Create a comment" do
			context "with Valid attributes to a medical case of sparring_mode exam" do
				before do
					@medical_case = Fabricate(:medical_case)
					post :create, {:exam=>"sparring_mode", "comment"=>{"comment"=>"asdf"}, :medical_case_id=>@medical_case.id}
				end
				it { should respond_with(406)                                                }
			end

			context "with Valid attributes to a question of sparring_mode exam" do
				before do
					@exam_question = Fabricate(:exam_question)
					post :create, {:exam=>"sparring_mode", "comment"=>{"comment"=>"asdf"}, :exam_question_id=>@exam_question.id}
				end
				it { should respond_with(406)                                                }
			end

			context "with Valid attributes to a medical case of exam_mode exam" do
				before do
					@medical_case = Fabricate(:medical_case)
					post :create, {:exam=>"exam_mode", "comment"=>{"comment"=>"asdf"}, :medical_case_id=>@medical_case.id}
				end
				it { should respond_with(406)                                                }
			end

			context "with Valid attributes to a question of exam_mode exam" do
				before do
					@exam_question = Fabricate(:exam_question)
					post :create, {:exam=>"exam_mode", "comment"=>{"comment"=>"asdf"}, :exam_question_id=>@exam_question.id}
				end
				it { should respond_with(406)                                                }
			end
		end
	end

	describe "SuperAdmin" do
		def logged_in_user
			invite = Fabricate(:invite)
			@user = Fabricate(:user, :email =>invite.email)
		end
		include_examples "users_comments"
	end
	describe "Admin" do
		def logged_in_user
			invite = Fabricate(:invite)
			@user = Fabricate(:user, {:email =>invite.email,:role_id => 2})
		end
		include_examples "users_comments"
	end
	describe "users" do
		def logged_in_user
			invite = Fabricate(:invite)
			@user = Fabricate(:user, {:email =>invite.email,:role_id => 3})
		end
		include_examples "users_comments"
	end
end
