require 'spec_helper'
describe ScoreBoardsHelper do

	describe "score_board_incomplete" do
		before :each do
			invite = Fabricate(:invite)
			@user = Fabricate(:user, :email =>invite.email)
			helper.stub!(:current_user).and_return(@user)
		end

		it "should show total time taken to write exam mode exam" do
			@medical_case = Fabricate(:medical_case)
      @exam_question = Fabricate(:exam_question,:medical_case_id =>@medical_case.id)
			Fabricate(:score_board, :exam_mode =>"exam_mode", :status=>"incomplete")
			a = helper.score_board_incomplete
			a.should be_true
		end

		
	end
end
