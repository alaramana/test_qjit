require 'spec_helper'
describe ApplicationHelper do

  describe "answer_status_icons" do
    before :each do
      invite = Fabricate(:invite)
      user = Fabricate(:user, :email =>invite.email)
      helper.stub!(:current_user).and_return(user)
      @medical_case = Fabricate(:medical_case)
    end
    # it "should show answer status icon" do
    #   a =  helper.answer_status_icons(@medical_case.id)
    #   a.should eq "question-sign"
    # end

    # it "should show answer status icon" do
    #   scoreboard = Fabricate(:score_board,:medical_case_id =>@medical_case.id)
    #   a =  helper.answer_status_icons(@medical_case.id)
    #   a.should eq "check-sign"
    # end

    # it "should show answer status icon" do
    #   scoreboard = Fabricate(:score_board,:medical_case_id =>@medical_case.id,:correct => false)
    #   a =  helper.answer_status_icons(@medical_case.id)
    #   a.should eq "x-sign"
    # end

  end


  # describe "question_answer_status_icons" do
  #   before :each do
  #     invite = Fabricate(:invite)
  #     user = Fabricate(:user, :email =>invite.email)
  #     helper.stub!(:current_user).and_return(user)
  #     @medical_case = Fabricate(:medical_case)
  #     @exam_question = Fabricate(:exam_question,:medical_case_id =>@medical_case.id)
  #   end
  #   it "should show question answer status icon" do
  #     a =  helper.question_answer_status_icons(@exam_question.id,@medical_case.id)
  #     a.should eq "question-sign"
  #   end

  #   it "should show question  answer status icon" do
  #     scoreboard = Fabricate(:score_board,:medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id)
  #     a =  helper.question_answer_status_icons(@exam_question.id,@medical_case.id)
  #     a.should eq "check-sign"
  #   end

  #   it "should show question answer status icon" do
  #     scoreboard = Fabricate(:score_board,:medical_case_id =>@medical_case.id,:correct => false,:exam_question_id =>@exam_question.id)
  #     a =  helper.question_answer_status_icons(@exam_question.id,@medical_case.id)
  #     a.should eq "x-sign"
  #   end
  # end

  describe "question_answer_history_icons" do
    before :each do
      invite = Fabricate(:invite)
      user = Fabricate(:user, :email =>invite.email)
      helper.stub!(:current_user).and_return(user)
      @medical_case = Fabricate(:medical_case)
      @exam_question = Fabricate(:exam_question,:medical_case_id =>@medical_case.id)
    end
    it "should show question answer status icon" do
      scoreboard = Fabricate(:score_board,:medical_case_id =>@medical_case.id,:correct => '',:exam_question_id =>@exam_question.id)
      a =  helper.question_answer_history_icons(scoreboard.correct)
      a.should eq "question-sign"
    end

    it "should show question  answer status icon" do
      scoreboard = Fabricate(:score_board,:medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id)
      a =  helper.question_answer_history_icons(scoreboard.correct)
      a.should eq "check-sign"
    end

    it "should show question answer status icon" do
      scoreboard = Fabricate(:score_board,:medical_case_id =>@medical_case.id,:correct => false,:exam_question_id =>@exam_question.id)
      a =  helper.question_answer_history_icons(scoreboard.correct)
      a.should eq "x-sign"
    end
  end






  describe "is_favorite" do
    before :each do
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
      helper.stub!(:current_user).and_return(@user)
    end
    # it "should show favorite icon" do
    #   @medical_case = Fabricate(:medical_case)
    #   favorite = Fabricate(:favorite, :medical_case_id =>@medical_case.id )
    #   a = helper.is_favorite(@user, @medical_case)
    #   a.should eq  "cstar"
    # end

    it "should show non favorite icon" do
      @medical_case = Fabricate(:medical_case)
      favorite = Fabricate(:favorite, :medical_case_id =>0 )
      b = helper.is_favorite(@user, @medical_case)
      b.should eq  "cstar gray"
    end


  end



  describe "is_question_favorite" do
    before :each do
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
      @medical_case = Fabricate(:medical_case)
      @exam_question = Fabricate(:exam_question,:medical_case_id =>@medical_case.id)
      helper.stub!(:current_user).and_return(@user)
    end
    # it "should show question favorite icon" do
    #   @medical_case = Fabricate(:medical_case)
    #   favorite = Fabricate(:favorite, :medical_case_id =>@medical_case.id,:exam_question_id=>@exam_question.id )
    #   a = helper.is_question_favorite(@user, @exam_question)
    #   a.should eq  "cstar"
    # end

    it "should show question non favorite icon" do
      @medical_case = Fabricate(:medical_case)
      favorite = Fabricate(:favorite, :medical_case_id =>0 )
      b = helper.is_question_favorite(@user, @exam_question)
      b.should eq  "cstar gray"
    end


  end




  # describe "medical_case_rating" do
  #   before :each do
  #     invite = Fabricate(:invite)
  #     user = Fabricate(:user, :email =>invite.email)
  #     helper.stub!(:current_user).and_return(user)
  #     @medical_case = Fabricate(:medical_case)
  #   end
  #   it "should show medical case rating" do
  #     @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:rate =>5 )
  #     a = helper.medical_case_rating(@rating.rate.to_i)
  #     a.should eq "value fist five"
  #   end

  #   it "should show medical case rating" do
  #     @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:rate =>4 )
  #     a = helper.medical_case_rating(@rating.rate.to_i)
  #     a.should eq "value fist four"
  #   end

  #   it "should show medical case rating" do
  #     @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:rate =>3 )
  #     a = helper.medical_case_rating(@rating.rate.to_i)
  #     a.should eq "value fist three"
  #   end

  #   it "should show medical case rating" do
  #     @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:rate =>2 )
  #     a = helper.medical_case_rating(@rating.rate.to_i)
  #     a.should eq "value fist two"
  #   end

  #   it "should show medical case rating" do
  #     @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:rate =>1 )
  #     a = helper.medical_case_rating(@rating.rate.to_i)
  #     a.should eq "value fist one"
  #   end
  # end


  describe "exam_medical_case_rating" do
    before :each do
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
      helper.stub!(:current_user).and_return(@user)
      @medical_case = Fabricate(:medical_case)
    end
    it "should show exam medical case rating" do
      @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:rate =>5 )
      a = helper.exam_medical_case_rating(@medical_case,@user)
      a.should eq "value fist five"
    end

    it "should show exam medical case rating" do
      @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:rate =>4 )
      a = helper.exam_medical_case_rating(@medical_case,@user)
      a.should eq "value fist four"
    end

    it "should show exam medical case rating" do
      @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:rate =>3 )
      a = helper.exam_medical_case_rating(@medical_case,@user)
      a.should eq "value fist three"
    end

    it "should show exam medical case rating" do
      @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:rate =>2 )
      a = helper.exam_medical_case_rating(@medical_case,@user)
      a.should eq "value fist two"
    end

    it "should show exam medical case rating" do
      @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:rate =>1 )
      a = helper.exam_medical_case_rating(@medical_case,@user)
      a.should eq "value fist one"
    end
  end


  describe "exam_question_rating" do
    before :each do
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
      helper.stub!(:current_user).and_return(@user)
      @medical_case = Fabricate(:medical_case)
      @exam_question = Fabricate(:exam_question,:medical_case_id =>@medical_case.id)
    end
    it "should show exam question rating" do
      @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:exam_question_id=>@exam_question.id,:rate =>5 )
      a = helper.exam_question_rating(@exam_question,@user)
      a.should eq "value fist five"
    end

    it "should show exam question rating" do
      @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:exam_question_id=>@exam_question.id,:rate =>4 )
      a = helper.exam_question_rating(@exam_question,@user)
      a.should eq "value fist four"
    end

    it "should show exam question rating" do
      @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:exam_question_id=>@exam_question.id,:rate =>3 )
      a = helper.exam_question_rating(@exam_question,@user)
      a.should eq "value fist three"
    end

    it "should show exam question rating" do
      @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:exam_question_id=>@exam_question.id,:rate =>2 )
      a = helper.exam_question_rating(@exam_question,@user)
      a.should eq "value fist two"
    end

    it "should show exam question rating" do
      @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id,:exam_question_id=>@exam_question.id,:rate =>1 )
      a = helper.exam_question_rating(@exam_question,@user)
      a.should eq "value fist one"
    end
  end



  describe "set_title_to_active" do
    it "should return Activate or Deactivate" do
      invite = Fabricate(:invite)
      user = Fabricate(:user,:email =>invite.email)
      test = set_title_to_active(user.active)
      user.active.should be_true
      test.should eq "Deactivate"

      user.update_attribute(:active, false)
      test1 = set_title_to_active(user.active)
      test1.should eq "Activate"
    end
  end




  describe "activate_admin_menu" do
    it "should retrun active or nil based on controller name" do
      a = activate_admin_menu("admin/medical_organizations")
      a.should eq "active"
      b = activate_admin_menu("admin/users")
      b.should eq "active"
      c = activate_admin_menu("admin/reports")
      c.should eq "active"
    end
  end

  describe "can_register?" do
    it "should retrun true or false" do
      invite = Fabricate(:invite)
      invite.status.should eq false
      a = can_register?(invite.invitation_token)
      a.status.should eq false
      invite.status = true
      invite.save
      b = can_register?(invite.invitation_token)
      b.should eq  false
      invite.update_attribute("updated_at",Time.now.utc-6.days)
      c = can_register?(invite.invitation_token)
      c.should eq false
    end
  end


  describe "user_belt" do
    it  "should return belt color" do
      a = user_belt("white")
      a.should eq "belt-white"
      b = user_belt("blue")
      b.should eq "belt-blue"
      c = user_belt("black")
      c.should eq "belt-black"
      d = user_belt("purple")
      d.should eq "belt-purple"
      e = user_belt("brown")
      e.should eq "belt-brown"
      f = user_belt("red")
      f.should eq "belt-red"
    end
  end



  # describe "medical_case_average_rating" do
  #   it "should show medical case average rating" do
  #     medical_case1 = Fabricate(:medical_case,:average_rating => 1)
  #     a = medical_case_average_rating(medical_case1)
  #     a.should eq "value fist one"


  #     medical_case2 = Fabricate(:medical_case,:average_rating => 2)
  #     b = medical_case_average_rating(medical_case2)
  #     b.should eq "value fist two"


  #     medical_case3= Fabricate(:medical_case,:average_rating => 3)
  #     c = medical_case_average_rating(medical_case3)
  #     c.should eq "value fist three"


  #     medical_case4 = Fabricate(:medical_case,:average_rating => 4)
  #     d = medical_case_average_rating(medical_case4)
  #     d.should eq "value fist four"


  #     medical_case5 = Fabricate(:medical_case,:average_rating => 5)
  #     e = medical_case_average_rating(medical_case5)
  #     e.should eq "value fist five"

  #   end
  # end

  # describe "exam_question_average_rating" do
  #   it "should show exam question average rating" do
  #     medical_case1 = Fabricate(:medical_case)
  #     exam_question1 = Fabricate(:exam_question,:average_rating =>1,:medical_case_id =>medical_case1.id)
  #     a = exam_question_average_rating(exam_question1)
  #     a.should eq "value fist one"

  #     medical_case2 = Fabricate(:medical_case)
  #     exam_question2 = Fabricate(:exam_question,:average_rating =>2,:medical_case_id =>medical_case2.id)
  #     a = exam_question_average_rating(exam_question2)
  #     a.should eq "value fist two"


  #     medical_case3 = Fabricate(:medical_case)
  #     exam_question3 = Fabricate(:exam_question,:average_rating =>3,:medical_case_id =>medical_case3.id)
  #     a = exam_question_average_rating(exam_question3)
  #     a.should eq "value fist three"

  #     medical_case4 = Fabricate(:medical_case)
  #     exam_question4 = Fabricate(:exam_question,:average_rating =>4,:medical_case_id =>medical_case4.id)
  #     a = exam_question_average_rating(exam_question4)
  #     a.should eq "value fist four"

  #     medical_case5 = Fabricate(:medical_case)
  #     exam_question5 = Fabricate(:exam_question,:average_rating =>5,:medical_case_id =>medical_case5.id)
  #     a = exam_question_average_rating(exam_question5)
  #     a.should eq "value fist five"
  #   end
  # end







  describe "number_of_exam" do
    before :each do
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
      helper.stub!(:current_user).and_return(@user)
    end
    it "should show number of questions of sparring_mode exam" do
      @medical_case = Fabricate(:medical_case)
      score_board = Fabricate(:score_board, :medical_case_id =>@medical_case.id )
      a = helper.number_of_exam(@user, score_board.exam_mode)
      a.should eq 1
    end
    it "should show number of questions of  exam_mode exam" do
      @medical_case = Fabricate(:medical_case)
      score_board = Fabricate(:score_board, :exam_mode =>"exam_mode",:medical_case_id =>@medical_case.id )
      a = helper.number_of_exam(@user, score_board.exam_mode)
      a.should eq 1
    end
  end

  describe "total_questions" do
    before :each do
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
      helper.stub!(:current_user).and_return(@user)
    end
    it "should show total  number of sparring_mode exam questions" do
      @medical_case = Fabricate(:medical_case)
      score_board = Fabricate(:score_board, :medical_case_id =>@medical_case.id )
      a = helper.total_questions(@user, score_board.exam_mode)
      a.should eq 1
    end
    it "should show total number of exam_mode exam questions" do
      @medical_case = Fabricate(:medical_case)
      score_board = Fabricate(:score_board, :exam_mode =>"exam_mode",:medical_case_id =>@medical_case.id )
      a = helper.total_questions(@user, score_board.exam_mode)
      a.should eq 1
    end
  end

  describe "user_high_score" do
    before :each do
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
      helper.stub!(:current_user).and_return(@user)
    end
    it "should show user high score of sparring_mode exam" do
      @medical_case = Fabricate(:medical_case)
      score_board = Fabricate(:score_board, :medical_case_id =>@medical_case.id )
      a = helper.user_high_score(@user)
      a.should eq 1
    end
    it "should show user high score of exam_mode exam" do
      @medical_case = Fabricate(:medical_case)
      score_board = Fabricate(:score_board, :correct =>false,:medical_case_id =>@medical_case.id )
      a = helper.user_high_score(@user)
      a.should eq 0
    end
  end


  describe "user_report_high_score" do
    before :each do
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
      helper.stub!(:current_user).and_return(@user)
    end
    it "should show user report high score of sparring_mode exam" do
      @medical_case = Fabricate(:medical_case)
      score_board = Fabricate(:score_board, :medical_case_id =>@medical_case.id )
      a = helper.user_report_high_score(@user, score_board.exam_mode)
      a.should eq 1
    end
    it "should show user report high score of exam_mode exam" do
      @medical_case = Fabricate(:medical_case)
      score_board = Fabricate(:score_board, :correct =>false,:medical_case_id =>@medical_case.id )
      a = helper.user_report_high_score(@user, score_board.exam_mode)
      a.should eq 0
    end

    it "should show user report high score of exam_mode exam" do
      @medical_case = Fabricate(:medical_case)
      score_board = Fabricate(:score_board, :exam_mode =>"exam_mode",:medical_case_id =>@medical_case.id )
      a = helper.user_report_high_score(@user, score_board.exam_mode)
      a.should eq 1
    end

    it "should show user report high score of exam_mode exam" do
      @medical_case = Fabricate(:medical_case)
      score_board = Fabricate(:score_board, :exam_mode =>"exam_mode",:correct =>false,:medical_case_id =>@medical_case.id )
      a = helper.user_report_high_score(@user, score_board.exam_mode)
      a.should eq 0
    end
  end

  describe "varify_invitation_token" do
    before :each do
      @invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>@invite.email)
      helper.stub!(:current_user).and_return(@user)
    end
    it "should check the invitation token exist or not" do
      a = helper.varify_invitation_token(@invite.invitation_token)
      a.should_not be_nil
    end
  end
end
