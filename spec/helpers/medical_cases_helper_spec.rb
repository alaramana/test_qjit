require 'spec_helper'
describe MedicalCasesHelper do

	describe "score_count" do
		before :each do
			invite = Fabricate(:invite)
			user = Fabricate(:user, :email =>invite.email)
			helper.stub!(:current_user).and_return(user)
		end


		it "should show the score count of sparing mode exam" do
			scoreboard = Fabricate(:score_board, :exam_mode =>"sparring_mode", :correct=>true, :status=>"incomplete")
			a = helper.score_count(scoreboard.exam_mode)
			a.should eq 1
		end


		it "should show the score count of exam mode" do
			scoreboard = Fabricate(:score_board, :exam_mode => "exam_mode",:correct=>false, :status=>"incomplete")
			b =  helper.score_count(scoreboard.exam_mode)
			b.should eq 0
		end

		it "should show the score count of exam mode" do
			46.times do
				@scoreboard = Fabricate(:score_board, :exam_mode => "exam_mode",:correct=>true, :status=>"incomplete")
			end
			c =  helper.score_count(@scoreboard.exam_mode)
			c.should eq 46
		end
	end



	describe "level" do
		it "should  return the level of user" do
			a = level(9)
			a.should eq  "Grass Hopper"
			b = level(19)
			b.should eq  "Fists of Fury"
			c = level(39)
			c.should eq  "Enter the Dragon"
			c = level(59)
			c.should eq  "Grand Master"
		end
	end

	describe "total_time_taken" do
		before :each do
			invite = Fabricate(:invite)
			user = Fabricate(:user, :email =>invite.email)
			helper.stub!(:current_user).and_return(user)
		end

		it "should show total time taken to write exam" do
			Fabricate(:score_board, :exam_mode =>"exam_mode", :correct=>true, :status=>"incomplete")
			a = helper.total_time_taken
			a.should_not eq nil
			a.should_not eq 0
		end
	end
end
