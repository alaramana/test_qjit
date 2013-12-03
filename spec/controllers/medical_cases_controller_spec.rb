require 'spec_helper'
describe MedicalCasesController do
  shared_examples_for "users_medical_cases" do
    before do
      @medical_case = Fabricate(:medical_case)
      sign_in :user, logged_in_user
    end

    describe "List medical cases" do
      context "should list medical cases with average rating as more than 3" do
        before do
          get :index,{:search =>{:average_rating_greater_than=>"3"}}
        end
        it { should respond_with(:success)              }
      end

      context "should  list favorite medical cases " do
        before do
          get :index,{:search =>{:favorites_is_active_is_true=>"yes"}}
        end
        it { should respond_with(:success)              }
      end


      context "should sort medical cases in created_at order" do
        before do
          get :index,{:order =>"created_at"}
        end
        it { should respond_with(:success)              }
      end

      context "should sort medical cases in personal order" do
        before do
          get :index,{:order =>"personal"}
        end
        it { should respond_with(:success)              }
      end


      context "should sort medical cases in average order" do
        before do
          get :index,{:order =>"average"}
        end
        it { should respond_with(:success)              }
      end


      context "should sort medical cases in author order" do
        before do
          get :index,{:order =>"author"}
        end
        it { should respond_with(:success)              }
      end

      context "should list medical cases in default order" do
        before do
          get :index,{:order =>""}
        end
        it { should respond_with(:success)              }
      end


      context "should list medical cases with a tag" do
        before do
          get :index,{:tag =>"a"}
        end
        it { should respond_with(:success)              }
      end

      context "should show auto complete tags" do
        before do
          5.times.each do
            Fabricate(:medical_case,:tag_list=> "awesome, slicka, heftya" )
          end
          get :index,{:search=>{:title_contains=>"a"}}
        end
        it { should respond_with(:success)}
      end


      context "should show auto complete tags"  do
        before do
          Fabricate(:medical_case,:tag_list=> "awesome, slicka, heftya" )
          get :index,{"search"=>{"title_contains"=>"", }, "tag_name"=>"awesome"}
        end
        it { should respond_with(:success)}
      end



      context "should show medical cases with rating as more than 3" do
        before do
          5.times.each do
            Fabricate(:medical_case)
          end
          get :index,{:search=>{:ratings_rate_greater_than=>"3"}}
        end
        it { should respond_with(:success)}
      end


      context "should search medical cases with author name" do
        before do
          5.times.each do
            Fabricate(:medical_case)
          end
          get :index,{:search=>{:user_firstname_contains=>"a"}}
        end
        it { should respond_with(:success)}
      end


      context "should show correct medical cases of current user" do
        before do
          @medical_case = Fabricate(:medical_case)
          Fabricate(:score_board ,:correct => true,:medical_case_id => @medical_case.id)
          get :index,{:search=>{:score_boards_correct_is_true=>"1"}, :not_answer=>"1"}
        end
        it { should respond_with(:success)}
      end

      context "Should list un answered medical cases" do
        before do
          get :index,{:search=>{:score_boards_user_id_eq=>"1"}, :not_answer=>"1"}
        end
        it { should respond_with(:success)              }
      end

      context "Should list correct/incorrect medical cases" do
        before do
          get :index,{:search=>{:score_boards_user_id_eq=>"1", :score_boards_correct_is_true=>"1", :score_boards_correct_is_false=>"1"}}
        end
        it { should respond_with(:success)              }
      end


      context "Should search medical cases with title" do
        before do
          get :index,{:search=>{:title_contains=>"a"}}
        end
        it { should respond_with(:success)              }
      end
    end

    context "Should add a new medical case" do
      before do
        get :new
      end
      it { should respond_with(:success)            }
    end

    describe "Create a medical case" do
      context "with Valid attributes" do
        before do
          post :create, {:medical_case => Fabricate.attributes_for(:medical_case),:search=>''}
        end
        it { should respond_with(:redirect)                                                }
        it { should redirect_to(medical_cases_path)                                }
        it { should set_the_flash[:notice].to('Medical case was successfully created. It moved for admin approval.')}
      end


      context "with Valid attributes" do
        before do
          post :create, {:medical_case => Fabricate.attributes_for(:medical_case),:status=>"draft",:search=>''}
        end
        it { should respond_with(:redirect)                                                }
        it { should redirect_to(medical_cases_path)                                }
        it { should set_the_flash[:notice].to("Your medical case is saved as a draft. In order to edit your medical case or submit your medical case to the community, please go to  <a href='/myprofile/user_cases'>My Profile</a>")}
      end

      context "with invalid attributes" do
        before do
          post :create, {:medical_case => {},:search=>'' }
        end
        it { should respond_with(:redirect)                                                }
        it { should set_the_flash[:alert].to('Medical case name already taken.')}
      end
    end

    context "Should add rating for a medical case "  do
      before do
        @medical_case = Fabricate(:medical_case)
        @rating = Fabricate.attributes_for(:rating,:medical_case_id =>@medical_case.id)
        post :ratings, {:idBox=>@medical_case.id, :rate=>3 }
      end
      it { should respond_with(:success)                                                }
    end

    context "Should update rating for a medical case " do
      before do
        @medical_case = Fabricate(:medical_case)
        @rating = Fabricate(:rating,:medical_case_id =>@medical_case.id)
        post :ratings, {:idBox=>@rating.medical_case_id, :rate=>4.to_i }
      end
      it { should respond_with(:success)                                                }
    end

    describe "Update a medical case"  do
      context "with valid attributes" do
        before do
          medical_case = Fabricate(:medical_case)
          put :update, {:medical_case=>Fabricate.attributes_for(:medical_case),:status =>"approved", :id=>medical_case.id}
        end
        it { should respond_with(:redirect)                                               }
        it { should redirect_to(medical_cases_path)                                }
        it { should set_the_flash[:notice].to('Medical case was successfully created. It moved for admin approval.')}
      end


      context "with valid attributes" do
        before do
          medical_case = Fabricate(:medical_case)
          put :update, {:medical_case=>Fabricate.attributes_for(:medical_case),:status =>"draft", :id=>medical_case.id}
        end
        it { should respond_with(:redirect)                                               }
        it { should redirect_to(medical_cases_path)                                }
        it { should set_the_flash[:notice].to("Your medical case is saved as a draft. In order to edit your medical case or submit your medical case to the community, please go to  <a href='/myprofile/user_cases'>My Profile</a>")}
      end

    end

    context "Should edit a medical case" do
      before do
        get :edit,{:id =>@medical_case.id}
      end
      it { should respond_with(:success)            }
    end


    context "Should edit a medical case" do
      before do
        get :show,{:id =>@medical_case.id}
      end
      it { should respond_with(:success)            }
    end


    context "Should make medical case as pending " do
      before do
        post :pending,{:id =>@medical_case.id}
      end
      it { should respond_with(:redirect)                                                }
      it { should redirect_to(medical_cases_path)                                }
    end


    context "Should approve a medical case" do
      before do
        post :pending,{:admin => "true", :id =>@medical_case.id}
      end
      it { should respond_with(:redirect)                                                }
      it { should redirect_to(user_cases_admin_users_url)                                }
    end



    context "Should approve a medical case" do
      before do
        post :approved,{:id =>@medical_case.id}
      end
      it { should respond_with(:redirect)                                                }
      it { should redirect_to(medical_cases_path)                                }
    end

    context "Should approve a medical case" do
      before do
        post :approved,{:admin => "true", :id =>@medical_case.id}
      end
      it { should respond_with(:redirect)                                                }
      it { should redirect_to(user_cases_admin_users_url)                                }
    end




    context "Should make a medical case as draft " do
      before do
        post :draft,{:id =>@medical_case.id}
      end
      it { should respond_with(:redirect)                                                }
      it { should redirect_to(medical_cases_path)                                }
    end


    context "Should approve a medical case" do
      before do
        post :draft,{:admin => "true", :id =>@medical_case.id}
      end
      it { should respond_with(:redirect)                                                }
      it { should redirect_to(user_cases_admin_users_url)                                }
    end


    context "Should inactivate a medical case" do
      before do
        post :inactive,{:id =>@medical_case.id}
      end
      it { should respond_with(:redirect)                                                }
      it { should redirect_to(medical_cases_path)                                }
    end

    context "Should approve a medical case" do
      before do
        post :inactive,{:admin => "true", :id =>@medical_case.id}
      end
      it { should respond_with(:redirect)                                                }
      it { should redirect_to(user_cases_admin_users_url)                                }
    end



    context "Should make a medical_case as favorite" do
      before do
        @medical_case = Fabricate(:medical_case)
        post :add, {:id =>@medical_case.id}
      end
      it { should respond_with(:success)                                                }
    end

    context "Should make a medical_case as non favorite" do
      before do
        @medical_case = Fabricate(:medical_case)
        @favorite = Fabricate(:favorite,:medical_case_id => @medical_case.id)
        post :remove, { :id =>@medical_case.id}
      end
      it { should respond_with(:success)                                                }
    end

    context "should show auto completed authors" do
      before do
        5.times.each do
          invite = Fabricate(:invite)
          Fabricate(:user,:firstname=>"ala",:email =>invite.email,:role_id=>invite.role_id)
        end
        get :autocomplete_author_name,{:name =>"a"}
      end
      it { should respond_with(:success)}
    end

    context "should show auto completed tags" do
      before do
        5.times.each do
          medical_case =  Fabricate(:medical_case,:tag_list=> "awesome, slicka, heftya" )
        end
        get :autocomplete_tag_name,{:name =>"a"}
      end
      it { should respond_with(:success)}
    end

    context "Should list  comments for a medical_case"  do
      before do
        medical_case = Fabricate(:medical_case,:status =>"approved",)
        Fabricate(:rating,:user_id =>@user.id, :rate =>4,:medical_case_id => medical_case.id)
        get :get_comments,{:id=>medical_case.id}
      end
      it { should respond_with(:success)}
    end

    context "should list tags for a medical_case" do
      before do
        medical_case =  Fabricate(:medical_case,:status =>"approved",:tag_list=> "awesome, slicka, heftya" )
        get :get_tags,{:id =>medical_case.id}
      end
      it { should respond_with(:success)}
    end


  end

  describe "SuperAdmin" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, :email =>invite.email)
    end
    include_examples "users_medical_cases"
  end
  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 2})
    end
    include_examples "users_medical_cases"
  end
  describe "users" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 3})
    end
    include_examples "users_medical_cases"
  end
end
