require 'spec_helper'

describe Admin::ObjectivesController do
  shared_examples_for "admin_objectives" do

    before do
      @objective = Fabricate(:objective)
      sign_in :user, logged_in_user
    end


    describe "List all Objectives" do
      context "List active Objectives" do
        before do
          @objective = Fabricate(:objective,:status=>true)
          get :index,{ :search=>{:status_is_true=>"active"}}
        end
        it { should respond_with(:success)            }
      end
      context "List suspended Objectives" do
        before do
          @objective = Fabricate(:objective,:status=>false)
          get :index,{ :search=>{:status_is_true=>"suspended"}}
        end
        it { should respond_with(:success)            }
      end
      context "Listall Objectives" do
        before do
          get :index,{:page => 1}
        end
        it { should respond_with(:success)            }
      end

    end

    context "Create new objective" do
      before do
        get :new
      end
      it { should respond_with(:success)            }
    end


    context "Edit a objective" do
      before do
        get :edit,{:id =>@objective.id}
      end
      it { should respond_with(:success)            }
    end


    describe "POST create" do
      context "Valid attributes" do
        before do
          post :create, {:objective => Fabricate.attributes_for(:objective)}
        end
        it { should respond_with(:redirect)                                                }
        it { should redirect_to(admin_objectives_path)                                }
        it { should set_the_flash[:notice].to('Assignment was successfully created.')}
      end
      context "Invalid attributes" do
        before do
          post :create, {:objective => {} }
        end
        it { should respond_with(:success)                                                }
        it { should render_template(:new)                                                 }
        it { should render_with_layout(:application)                                      }
        it { should_not set_the_flash                                                     }
      end
    end



    describe "Update a objective" do
      context "Valid attributes" do
        before do
          put :update, {:id => @objective.id, :objective =>Fabricate.attributes_for(:objective)}
        end
        it { should respond_with(:redirect)                                               }
        it { should redirect_to(admin_objectives_path)     }
        it { should set_the_flash[:notice].to('Assignment was successfully updated.')         }
      end

      context "Invalid attributes" do
        before do
          put :update, {:id => @objective.id, :objective => {:name =>""}}
        end
        it { should respond_with(:success)                                                }
        it { should render_template(:edit)                                                }
      end
    end

        describe "Change the status of objective"  do
      before do
        @objectived = Fabricate(:objective,:status =>true)
        exam_question = Fabricate(:exam_question)
        exam_question.update_attribute(:objective_id, @objectived.id)
      end
      context "should be able to deactivate  a objective " do
        before do
          objective = Fabricate(:objective,:status=> true)
          get :toggle_status,{:id =>objective.id}
        end
        it { should respond_with(:redirect)                  }
        it { should redirect_to(admin_objectives_path)  }
        it { should set_the_flash }
      end
      context "should be able to activate a objective " do
        before do
          objective = Fabricate(:objective,:status=> false)
          get :toggle_status,{:id =>objective.id}
        end
        it { should respond_with(:redirect)                  }
        it { should redirect_to(admin_objectives_path)  }
        it { should set_the_flash }
      end
      context "should not be able to deactivate a objective" do
        before do
          get :toggle_status,{:id => @objectived.id}
        end
        it {should respond_with(:redirect)      }
        it { should redirect_to(admin_objectives_path)  }
        it { should set_the_flash }
      end
    end

  end
  describe "SuperAdmin" do
    def logged_in_user
      invite = Fabricate(:invite,:role_id=>1)
      @user = Fabricate(:user, :email =>invite.email,:role_id=>invite.role_id)
    end
    include_examples "admin_objectives"
  end

  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite,:role_id=>2)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => invite.role_id})
    end
    include_examples "admin_objectives"
  end

end
