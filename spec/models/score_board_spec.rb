# == Schema Information
#
# Table name: score_boards
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  medical_case_id  :integer
#  correct          :boolean
#  status           :string(255)
#  answer           :string(255)
#  time_taken       :string(255)
#  exam_mode        :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exam_number      :integer          default(1), not null
#  attempt          :integer          default(1), not null
#  exam_question_id :integer
#

require 'spec_helper'
include UserHelper
describe ScoreBoard do
	context "Mass assignment" do
		it { should allow_mass_assignment_of(:batch)}
		it { should allow_mass_assignment_of(:medical_case_id)}
		it { should allow_mass_assignment_of(:correct)}
		it { should allow_mass_assignment_of(:status)}
		it { should allow_mass_assignment_of(:time_taken)}
		it { should allow_mass_assignment_of(:exam_mode)}
		it { should allow_mass_assignment_of(:answer)}
		it { should allow_mass_assignment_of(:exam_number)}
		it { should allow_mass_assignment_of(:user_id)}
	end

	context "Associations" do
		it { should belong_to(:user)}
		it { should belong_to(:medical_case)}
	end

	context "update_question_attempt" do
		it "should update question attempt count" do
			medical_case = Fabricate(:medical_case)
			score_board = Fabricate(:score_board,:correct => false)
			score_board.attempt.should eq 1
			score_board.update_attributes(:correct => true)
			score_board.attempt.should eq 2
		end
	end

	context ".exam_question_result" do
		before do
			@race = Fabricate(:race)
			@objective = Fabricate(:objective)
			@user = create_admin_with_invitation

		end

		it "should show result of exam" do
			medical_case =Fabricate(:medical_case,:creator_id=>@user.id,:race_id =>@race.id)
			exam_question = Fabricate(:exam_question,:objective_id =>@objective.id,:medical_case_id=>medical_case.id,:creator_id=>@user.id)
			score_board = Fabricate(:score_board , :medical_case_id => medical_case.id,:exam_question_id=>exam_question.id)
			ScoreBoard.exam_question_result(@user,{:exam_question=>exam_question.id, :score_board=>{ "exam_mode"=>"sparring_mode", "medical_case_id"=>medical_case.id, "answer"=>"Gisselle Dickinson"}}).should_not be_nil
		end

		it "should set exam_number as 1 for sparring_mode" do
			medical_case =Fabricate(:medical_case,:creator_id=>@user.id,:race_id =>@race.id)
			exam_question = Fabricate(:exam_question,:objective_id =>@objective.id,:medical_case_id=>medical_case.id,:creator_id=>@user.id)
			ScoreBoard.exam_question_result(@user,{:exam_question=>exam_question.id, :score_board=>{ "exam_mode"=>"sparring_mode", "medical_case_id"=>medical_case.id, "answer"=>"Gisselle Dickinson"}}).should_not be_nil
		end

		it "should set exam_number as 1 for exam_mode" do
			medical_case =Fabricate(:medical_case,:creator_id=>@user.id,:race_id =>@race.id)
			exam_question = Fabricate(:exam_question,:objective_id =>@objective.id,:medical_case_id=>medical_case.id,:creator_id=>@user.id)
			score_board = Fabricate(:score_board , :medical_case_id => medical_case.id,:exam_question_id=>exam_question.id)
			ScoreBoard.exam_question_result(@user,{:exam_question=>exam_question.id, :score_board=>{ "exam_mode"=>"exam_mode", "medical_case_id"=>medical_case.id, "answer"=>"Gisselle Dickinson"}}).should_not be_nil
		end

		# it "should increase exam_number by 1" do
		# 	medical_case =Fabricate(:medical_case,:creator_id=>@user.id,:race_id =>@race.id)
		# 	exam_question = Fabricate(:exam_question,:objective_id =>@objective.id,:medical_case_id=>medical_case.id,:creator_id=>@user.id)
		# 	score_board = Fabricate(:score_board ,:status=>"completed", :medical_case_id => medical_case.id,:exam_question_id=>exam_question.id,:user_id=>@user.id)
		# 	ScoreBoard.exam_question_result(@user,{:exam_question=>exam_question.id, :score_board=>{ "exam_mode"=>"exam_mode",:status=>nil,:correct=>false, "medical_case_id"=>medical_case.id, "answer"=>"Gisselle Dickinson"}}).should_not be_nil
		# end

	end


	context ".sparring_records" do
		before do
			@race = Fabricate(:race)
			@objective = Fabricate(:objective)
			@user = create_admin_with_invitation
		end
		it "should show sparring records" do
			medical_case =Fabricate(:medical_case,:creator_id=>@user.id,:race_id =>@race.id)
			exam_question = Fabricate(:exam_question,:objective_id =>@objective.id,:medical_case_id=>medical_case.id,:creator_id=>@user.id)
			score_board = Fabricate(:score_board ,:medical_case_id => medical_case.id,:exam_question_id=>exam_question.id)
			ScoreBoard.sparring_records({:exam_question=>exam_question.id, :score_id=>score_board.id, :score_board=>{ "exam_mode"=>"sparring_mode", "answer"=>"cpt"}}).should_not be_nil
		end
	end


end
