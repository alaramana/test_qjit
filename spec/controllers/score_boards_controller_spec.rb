require 'spec_helper'
describe ScoreBoardsController do
  shared_examples_for "users_score_boards" do
    before do
      @medical_case = Fabricate(:medical_case)
      sign_in :user, logged_in_user
    end

    describe "Create a score board"  do
      context "with Valid attributes of sparring mode" do
        before do
          @medical_case = Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id => @medical_case.id)
          @score_board = Fabricate(:score_board , :medical_case_id => @medical_case.id,:exam_question_id=>@exam_question.id)
          post :create, {:score_board => Fabricate.attributes_for(:score_board),:medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id,:search=>'{"page"=>"2"}'}
        end
        it { should respond_with(:redirect)                                                }
      end

      context "with Valid attributes of sparring mode" do
        before do
          @medical_case = Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id => @medical_case.id)
          @score_board = Fabricate(:score_board, :medical_case_id => @medical_case.id,:exam_question_id=>@exam_question.id)
          post :create, {:score_board => Fabricate.attributes_for(:score_board,:exam_mode =>"exam_mode"),:medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id,:search=>'{"page"=>"2"}'}
        end
        it { should respond_with(:redirect)                                                }
      end


      context "with Valid attributes of sparring mode" do
        before do
          @medical_case = Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id => @medical_case.id)
          @score_board = Fabricate(:score_board, :medical_case_id => @medical_case.id,:exam_question_id=>@exam_question.id)
          post :create, {:score_board => Fabricate.attributes_for(:score_board,:exam_mode=>""),:medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id, :search=>'{"page"=>"2"}'}
        end
        it { should respond_with(:redirect)                                                }
      end

      context "with Valid attributes of sparring mode" do
        before do
          @medical_case = Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id => @medical_case.id)
          post :create, {:score_board => Fabricate.attributes_for(:score_board,:exam_mode=>""),:medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id,:search=>'{"page"=>"2"}'}
        end
        it { should respond_with(:redirect)                                                }
      end
    end


    describe "update a score_board" do
      context "with Valid attributes" do
        before do
          @medical_case = Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id => @medical_case.id)
          @score_board =Fabricate(:score_board, :correct=> false, :status=> "incomplete", :answer=> "ajfdl",:exam_number => 2,:medical_case_id => @medical_case.id,:exam_question_id =>@exam_question.id)
          put :update, {:score_board=>{:exam_mode=>"sparring_mode", :answer=>"cpt"}, :medical_case_id=>@medical_case.id,:exam_question_id =>@exam_question.id, "id"=>@score_board.id,:search=>'{"page"=>"2"}'}
        end
        it { should respond_with(:redirect)                                                }
      end


      context "with Valid attributes" do
        before do
          @medical_case = Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id => @medical_case.id)
          @score_board =Fabricate(:score_board, :correct=> false, :status=> "incomplete", :answer=> "ajfdl",:exam_number => 2,:medical_case_id => @medical_case.id,:exam_question_id =>@exam_question.id)
          put :update, {:score_board=>{:exam_mode=>"exam_mode", :answer=>"cpt"}, :medical_case_id=>@medical_case.id,:exam_question_id =>@exam_question.id, "id"=>@score_board.id,:search=>'{"page"=>"2"}'}
        end
        it { should respond_with(:redirect)                                                }
      end
    end
  end

  describe "SuperAdmin" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
    end
    include_examples "users_score_boards"
  end
  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 2})
    end
    include_examples "users_score_boards"
  end
  describe "users" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 3})
    end
    include_examples "users_score_boards"
  end
end