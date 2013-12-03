require 'spec_helper'
describe ExamQuestionsController do
  shared_examples_for "users_exam_questions" do
    before do
      @exam_question = Fabricate(:exam_question)
      sign_in :user, logged_in_user
    end

    describe "List exam questions" do
      context "should list exam questions with average rating as more than 3" do
        before do
          get :index,{:search =>{:average_rating_greater_than=>"3"}}
        end
        it { should respond_with(:success)              }
      end

      context "should list avg as hidden exam questions " do
        before do
          objective = Fabricate(:objective,name: "assign1", suspended: false,  start_date: Date.today+1.day, end_date: Date.today+1.month , hide_author: true, hide_feedback: true)
          Fabricate(:exam_question,:objective_id =>objective.id)
          get :index,{:search=>{:average_rating_greater_than=>"hidden"}}
        end
        it { should respond_with(:success)              }
      end

      context "should  list favorite exam questions " do
        before do
          get :index,{:search =>{:favorites_is_active_is_true=>"yes"}}
        end
        it { should respond_with(:success)              }
      end


      context "should sort exam questions in created_at order" do
        before do
          get :index,{:order =>"created_at"}
        end
        it { should respond_with(:success)              }
      end

      context "should sort exam questions in personal order" do
        before do
          get :index,{:order =>"personal"}
        end
        it { should respond_with(:success)              }
      end


      context "should sort exam questions in average order" do
        before do
          get :index,{:order =>"average"}
        end
        it { should respond_with(:success)              }
      end


      context "should sort exam questions in author order" do
        before do
          get :index,{:order =>"author"}
        end
        it { should respond_with(:success)              }
      end

      context "should sort exam questions in review order" do
        before do
          get :index,{:order =>"review"}
        end
        it { should respond_with(:success)              }
      end

      context "should list exam questions in default order" do
        before do
          get :index,{:order =>""}
        end
        it { should respond_with(:success)              }
      end


      context "should list exam questions with a tag" do
        before do
          get :index,{:tag =>"a"}
        end
        it { should respond_with(:success)              }
      end

      context "should show auto complete tags" do
        before do
          5.times.each do
            Fabricate(:exam_question,:tag_list=> "awesome, slicka, heftya" )
          end
          get :index,{:search=>{:question_prompt_contains=>"a"}}
        end
        it { should respond_with(:success)}
      end


      context "should show exam questions with rating as more than 3" do
        before do
          5.times.each do
            Fabricate(:exam_question)
          end
          get :index,{:search=>{:ratings_rate_greater_than=>"3"}}
        end
        it { should respond_with(:success)}
      end


      context "should search exam questions with author name" do
        before do
          5.times.each do
            Fabricate(:exam_question)
          end
          get :index,{:search=>{:user_firstname_contains=>"a"}}
        end
        it { should respond_with(:success)}
      end

      context "should search hidden exam questions" do
        before do
          objective = Fabricate(:objective,name: "assign1", suspended: false,  start_date: Date.today+1.day, end_date: Date.today+1.month , hide_author: true, hide_feedback: true)
          Fabricate(:exam_question,:objective_id =>objective.id)
          get :index,{:search=>{:user_firstname_contains=>"hidden"}}
        end
        it { should respond_with(:success)}
      end


      context "should show correct exam questions of current user" do
        before do
          @exam_question = Fabricate(:exam_question)
          Fabricate(:score_board ,:correct => true,:exam_question_id => @exam_question.id)
          get :index,{:search=>{:score_boards_correct_is_true=>"1"}, :not_answer=>"1"}
        end
        it { should respond_with(:success)}
      end

      context "Should list un answered exam questions" do
        before do
          get :index, {:search=>{"question_prompt_contains"=>""},  "not_answer"=>"1"}
        end
        it { should respond_with(:success)              }
      end

      context "Should list objective questions" do
        before do
          objective = Fabricate(:objective)
          get :index, { "search"=>{ "objective_name_contains"=>objective.id}}
        end
        it { should respond_with(:success)              }
      end


      context "Should list objective questions" do
        before do
          objective = Fabricate(:objective)
          Fabricate(:exam_question,:objective_id => objective.id )
          get :index, {"search"=>{"objective_name_contains"=>"1"}}

        end
        it { should respond_with(:success)              }
      end


      context "Should list correct/incorrect exam questions" do
        before do
          get :index,{:search=>{:score_boards_user_id_eq=>"1", :score_boards_correct_is_true=>"1", :score_boards_correct_is_false=>"1"}}
        end
        it { should respond_with(:success)              }
      end


      context "Should search exam questions with title" do
        before do
          get :index,{:search=>{:question_prompt_contains=>"a"}}
        end
        it { should respond_with(:success)              }
      end
    end

    context "Should add a new exam question" do
      before do
        get :new
      end
      it { should respond_with(:success)            }
    end

    describe "Create a exam question" do
      context "with Valid attributes" do
        before do
          post :create, {:exam_question => Fabricate.attributes_for(:exam_question),:search=>''}
        end
        it { should respond_with(:redirect)                                                }
        it { should redirect_to(exam_questions_path)                                }
      end


      context "with Valid attributes" do
        before do
          post :create, {:exam_question => Fabricate.attributes_for(:exam_question),:status=>"draft",:search=>''}
        end
        it { should respond_with(:redirect)                                                }
        it { should redirect_to(exam_questions_path)                                }
      end

      context "with invalid attributes" do
        before do
          post :create, {:exam_question => {} ,:search=>''}
        end
        it { should respond_with(:redirect)                                                }
        it { should redirect_to(exam_questions_path)                                }
        it { should set_the_flash[:alert].to("Question prompt can't be blank, please try again")}
      end
    end

    context "Should add rating for a exam question "  do
      before do
        @exam_question = Fabricate(:exam_question)
        @rating = Fabricate.attributes_for(:rating,:exam_question_id =>@exam_question.id)
        post :ratings, {:idBox=>@exam_question.id, :rate=>3 }
      end
      it { should respond_with(:success)                                                }
    end

    context "Should update rating for a exam question " do
      before do
        @exam_question = Fabricate(:exam_question)
        @rating = Fabricate(:rating,:exam_question_id =>@exam_question.id)
        post :ratings, {:idBox=>@rating.exam_question_id, :rate=>4.to_i }
      end
      it { should respond_with(:success)                                                }
    end

    context "Should edit a exam question" do
      before do
        get :edit,{:id =>@exam_question.id}
      end
      it { should respond_with(:success)            }
    end

    describe "Update a exam question"  do
      context "with valid attributes" do
        before do
          exam_question = Fabricate(:exam_question,:status =>"draft")
          put :update, {:exam_question=>Fabricate.attributes_for(:exam_question),:status =>"approved", :id=>exam_question.id}
        end
        it { should respond_with(:redirect)                                               }
      end

      context "with valid attributes" do
        before do
          exam_question = Fabricate(:exam_question,:status =>"draft")
          put :update, {:exam_question=>Fabricate.attributes_for(:exam_question),:status =>"draft", :id=>exam_question.id}
        end
        it { should respond_with(:redirect)                                               }
      end

      context "with invalid attributes" do
        before do
          exam_question = Fabricate(:exam_question,:status =>"draft")
          put :update, {:exam_question=>Fabricate.attributes_for(:exam_question,:question_prompt=>""),:status =>"draft", :id=>exam_question.id}
        end
        it { should respond_with(:redirect)                                               }
        it { should set_the_flash }
      end
    end

    describe "overview of exams" do
      context "Should show the overview of test mode exam" do
        before do
          Fabricate(:score_board, :exam_mode =>"exam_mode")
          get :overview, {:exam=>"exam_mode"}
        end
        it { should respond_with(:success)}
      end

      context "Should show the overview of sparing mode exam" do
        before do
          Fabricate(:score_board, :exam_mode =>"sparring_mode")
          get :overview, {:exam=>"sparring_mode"}
        end
        it { should respond_with(:success)}
      end

      context "Should redirect to  exam_questions_path if no score_board" do
        before do
          get :overview, {:exam=>"sparring_mode"}
        end
        it { should respond_with(:redirect)}
      end

    end

    context "Should make a exam_question as favorite" do
      before do
        @exam_question = Fabricate(:exam_question)
        post :add, {:id =>@exam_question.id}
      end
      it { should respond_with(:success)                                                }
    end

    context "Should make a exam_question as non favorite" do
      before do
        @exam_question = Fabricate(:exam_question)
        @favorite = Fabricate(:favorite,:exam_question_id => @exam_question.id)
        post :remove, { :id =>@exam_question.id}
      end
      it { should respond_with(:success)                                                }
    end

    context "should show auto completed tags" do
      before do
        5.times.each do
          exam_question =  Fabricate(:exam_question,:tag_list=> "awesome, slicka, heftya" )
        end
        get :autocomplete_tag_name,{:name =>"a"}
      end
      it { should respond_with(:success)}
    end


    context "Should take sparring mode exam" do
      before do
        medical_case = Fabricate(:medical_case)
        exam_question = Fabricate(:exam_question,:medical_case_id =>medical_case.id)
        Fabricate(:score_board,:medical_case_id=>medical_case.id,:exam_question_id =>exam_question.id,:status=>"completed", :exam_mode =>"sparring_mode")
        post :sparring_mode, {:id=>medical_case.id, :question=>exam_question.id }
      end
      it { should respond_with(:success)}
    end

    context "Should take exam mode exam"  do
      before do
        objective = Fabricate(:objective)
        exam_question = Fabricate(:exam_question,:objective_id =>objective.id)
        5.times.each do
          Fabricate(:score_board,:exam_mode =>"exam_mode")
        end
        post :exam_mode, {:page=>"1"}
      end
      it { should respond_with(:success)}
    end

    context "Should list  comments for a exam question"  do
      before do
        exam = Fabricate(:exam_question)
        Fabricate(:rating,:user_id =>@user.id, :rate =>4,:exam_question_id => exam.id)
        get :get_comments,{:id=>exam.id}
      end
      it { should respond_with(:success)}
    end

    context "should list tags for a exam question" do
      before do
        exam_question =  Fabricate(:exam_question,:tag_list=> "awesome, slicka, heftya" )
        get :get_tags,{:id =>exam_question.id}
      end
      it { should respond_with(:success)}
    end


  end

  describe "SuperAdmin" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
    end
    include_examples "users_exam_questions"
  end
  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 2})
    end
    include_examples "users_exam_questions"
  end
  describe "users" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 3})
    end
    include_examples "users_exam_questions"
  end
end
