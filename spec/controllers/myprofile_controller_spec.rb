require 'spec_helper'

describe MyprofileController do
  shared_examples_for "all_users_profiles" do
    before do
      sign_in :user, logged_in_user
    end

    context "Edit a user" do
      before do
        get :edit,{}
      end
      it { should respond_with(:success)            }
    end

    describe "PUT update" do
      context "Valid attributes" do
        before do
          put :update, {:id =>@user.id, :user =>{:firstname =>"cpt"}}
        end
        it { should respond_with(:redirect)                                               }
        it { should redirect_to(myprofile_path)     }
        it { should set_the_flash[:notice].to('Your profile updated successfully')         }
      end

      context "Invalid attributes" do
        before do
          put :update, { :user => {:zip =>"cpt"}}
        end
        it { should respond_with(:success)                                               }
        it { should render_template("myprofile/edit")     }
        it { should render_with_layout(:application)}
      end

      context "Valid attributes" do
        before do
          put :update, {:id =>@user.id, :user =>{:password => 'password', :password_confirmation => 'password'}}
        end
        it { should respond_with(:redirect)                                               }
        it { should redirect_to(user_session_path)     }
        it { should set_the_flash[:notice].to('Password updated successfully, please Login')         }
      end

      context "Invalid attributes" do
        before do
          put :update, { :user => {:password => 'password', :password_confirmation => ''}}
        end
        it { should respond_with(:success)                                               }
        it { should render_template("myprofile/edit")     }
        it { should render_with_layout(:application)}
      end
    end

    context "List user cases" do
      before do
        @medical_case =  Fabricate(:medical_case)
        get :user_cases, {:page => 1}
      end
      it { @medical_case.stub!(:current_page).and_return(1)}
      it { @medical_case.stub!(:num_pages).and_return(1) }
      it { @medical_case.stub!(:limit_value).and_return(1) }
      it { should respond_with(:success)            }
      it { should render_template("myprofile/user_cases")}
      it { should render_with_layout(:application)  }
    end


    context "List user cases" do
      before do
        500.times do
          @medical_case =  Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id=>@medical_case.id)
          Fabricate(:score_board, :medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id)
        end
        get :exam_questions
      end

      it { should respond_with(:success)            }
    end

    context "List user cases" do
      before do
        400.times do
          @medical_case =  Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id=>@medical_case.id)
          Fabricate(:score_board, :medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id)
        end
        get :exam_questions
      end

      it { should respond_with(:success)            }
    end


    context "List user cases" do
      before do
        300.times do
          @medical_case =  Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id=>@medical_case.id)
          Fabricate(:score_board, :medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id)
        end
        get :exam_questions
      end

      it { should respond_with(:success)            }
    end


    context "List user cases" do
      before do
        200.times do
          @medical_case =  Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id=>@medical_case.id)
          Fabricate(:score_board, :medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id)
        end
        get :exam_questions
      end

      it { should respond_with(:success)            }
    end


    context "List user cases" do
      before do
        100.times do
          @medical_case =  Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id=>@medical_case.id)
          Fabricate(:score_board, :medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id)
        end
        get :exam_questions
      end

      it { should respond_with(:success)            }
    end

    context "List user cases" do
      before do
        2.times do
          @medical_case =  Fabricate(:medical_case)
          Fabricate(:score_board, :medical_case_id =>@medical_case.id)
        end
        get :user_cases
      end

      it { should respond_with(:success)            }
    end

    context "List user exam questions" do
      before do
        2.times do
          @medical_case =  Fabricate(:medical_case)
          @exam_question = Fabricate(:exam_question,:medical_case_id=>@medical_case.id)
          Fabricate(:score_board, :medical_case_id =>@medical_case.id,:exam_question_id =>@exam_question.id)
        end
        get :exam_questions
      end

      it { should respond_with(:success)            }
    end




    context "Show user history" do
      before do
        @medical_case =  Fabricate(:medical_case)
        get :user_history, {:page => 1}
      end
      it { @medical_case.stub!(:current_page).and_return(1)}
      it { @medical_case.stub!(:num_pages).and_return(1) }
      it { @medical_case.stub!(:limit_value).and_return(1) }
      it { should respond_with(:success)            }
      it { should render_template("myprofile/user_history")}
      it { should render_with_layout(:application)  }
    end

    context "should render error page" do
      before do
        get :routing
      end
        it { should respond_with(404) }
    end

  end
  describe "SuperAdmin" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
    end
    include_examples "all_users_profiles"
  end

  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 2})
    end
    include_examples "all_users_profiles"
  end
  describe "users" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 3})
    end
    include_examples "all_users_profiles"
  end
  shared_examples_for "inactive_user" do
    before do
      sign_in :user, inactive_logged_in_user
    end

    describe "PUT update" do
      context "profile update with valid attributes" do
        before do
          put :update, {:id =>@user.id, :user =>{:firstname =>"cpt"}}
        end

        it { should respond_with(:redirect)                                               }
        it { should redirect_to(user_session_path)     }
        it { should set_the_flash[:alert].to('You are not allowed to access the page.')         }
      end

      context "password update with valid attributes" do
        before do
          put :update, {:id =>@user.id, :user =>{:password => 'password', :password_confirmation => 'password'}}
        end
        it { should respond_with(:redirect)                                               }
        it { should redirect_to(user_session_path)     }
        it { should set_the_flash[:alert].to('You are not allowed to access the page.')         }
      end
    end
  end
  describe "normal user" do
    def inactive_logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 3,:active =>false})
    end
    include_examples "inactive_user"
  end
end
