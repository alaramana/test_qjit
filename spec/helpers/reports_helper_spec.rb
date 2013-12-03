require 'spec_helper'
describe ReportsHelper do

	describe "total_time_taken_report" do
		before :each do
			invite = Fabricate(:invite)
			@user = Fabricate(:user, :email =>invite.email)
			helper.stub!(:current_user).and_return(@user)
		end

		it "should show total time taken to write exam mode exam" do
			exam_mode_score = Fabricate(:score_board, :exam_mode =>"exam_mode", :correct=>true, :status=>"completed")
			a = helper.total_time_taken_report(@user,exam_mode_score.exam_mode)
			a.should_not eq nil
			a.should_not eq 0
		end

		it "should show total time taken to write  sparring mode exam" do
			sparring_mode_score = Fabricate(:score_board, :correct=>true, :status=>"completed")
			a = helper.total_time_taken_report(@user,sparring_mode_score.exam_mode)
			a.should_not eq nil
			a.should_not eq 0
		end
	end
end
