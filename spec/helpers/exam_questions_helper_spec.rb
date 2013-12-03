require 'spec_helper'
describe ExamQuestionsHelper do

	describe "score_count" do
		before :each do
			invite = Fabricate(:invite,:role_id =>2)
			@user = Fabricate(:user, :email =>invite.email)
			helper.stub!(:current_user).and_return(@user)
		end


		it "should show the score count of sparing mode exam" do
			objective = Fabricate(:objective,name: "assign1", suspended: false,  start_date: Date.today+1.day, end_date: Date.today+1.month , hide_author: true, hide_feedback: true)
			exam_question = Fabricate(:exam_question,:objective_id =>objective.id)
			a = helper.question_author(exam_question)
			a.should eq "Hidden"
		end

		it "should show the score count of sparing mode exam" do
			objective = Fabricate(:objective,name: "assign2")
			exam_question = Fabricate(:exam_question,:objective_id =>objective.id,:creator_id=>@user.id)
			a = helper.question_author(exam_question)
			a.should eq exam_question.user.full_name
		end

		it "should show the score count of sparing mode exam" do
			exam_question = Fabricate(:exam_question,:objective_id =>nil,:creator_id=>@user.id)
			a = helper.question_author(exam_question)
			a.should eq exam_question.user.full_name
		end


		it "should show the score count of sparing mode exam" do
			objective = Fabricate(:objective,name: "assign3", suspended: false,  start_date: Date.today+1.day, end_date: Date.today+1.month , hide_author: true, hide_feedback: true)
			exam_question = Fabricate(:exam_question,:objective_id =>objective.id)
			a = helper.question_feedback(exam_question)
			a.should eq "Hidden"
		end
	end

end



