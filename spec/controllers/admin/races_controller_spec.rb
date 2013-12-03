require 'spec_helper'

describe Admin::RacesController do
  shared_examples_for "admin_races" do

    before do
      @race = Fabricate(:race)
      sign_in :user, logged_in_user
    end


    describe "List all races" do
      context "List active races" do
        before do
          @race = Fabricate(:race,:status=>true)
          get :index,{ :search=>{:status_is_true=>"active"}}
        end
        it { should respond_with(:success)            }
      end
      context "List suspended races" do
        before do
          @race = Fabricate(:race,:status=>false)
          get :index,{ :search=>{:status_is_true=>"suspend"}}
        end
        it { should respond_with(:success)            }
      end
      context "Listall races" do
        before do
          get :index,{:page => 1}
        end
        it { should respond_with(:success)            }
      end

    end

    context "Create new race" do
      before do
        get :new
      end
      it { should respond_with(:success)            }
    end


    context "Edit a race" do
      before do
        get :edit,{:id =>@race.id}
      end
      it { should respond_with(:success)            }
    end


    describe "POST create" do
      context "Valid attributes" do
        before do
          post :create, {:race => Fabricate.attributes_for(:race)}
        end
        it { should respond_with(:redirect)                                                }
        it { should redirect_to(admin_races_path)                                }
        it { should set_the_flash[:notice].to('Race was successfully created.')}
      end
      context "Invalid attributes" do
        before do
          post :create, {:race => {} }
        end
        it { should respond_with(:success)                                                }
        it { should render_template(:new)                                                 }
        it { should render_with_layout(:application)                                      }
        it { should_not set_the_flash                                                     }
      end
    end



    describe "Update a race" do
      context "Valid attributes" do
        before do
          put :update, {:id => @race.id, :race =>Fabricate.attributes_for(:race)}
        end
        it { should respond_with(:redirect)                                               }
        it { should redirect_to(admin_races_path)     }
        it { should set_the_flash[:notice].to('Race was successfully updated.')         }
      end

      context "Invalid attributes" do
        before do
          put :update, {:id => @race.id, :race => {:name =>""}}
        end
        it { should respond_with(:success)                                                }
        it { should render_template(:edit)                                                }
      end
    end

   
    describe "Change the status of race"  do
      before do
        @raced = Fabricate(:race,:status =>true)
        medical_case = Fabricate(:medical_case)
        medical_case.update_attribute(:race_id, @raced.id)
      end
      context "should be able to active or deactivate  a race " do
        before do
          race = Fabricate(:race,:status => true)
          get :toggle_status,{:id =>race.id}
        end
        it { should respond_with(:redirect)                  }
        it { should redirect_to(admin_races_path)  }
        it { should set_the_flash }
      end
      context "should be able to deactivate a race " do
        before do
          race = Fabricate(:race,:status => false)
          get :toggle_status,{:id =>race.id}
        end
        it { should respond_with(:redirect)                  }
        it { should redirect_to(admin_races_path)  }
        it { should set_the_flash }
      end
      context "should not be able to deactivate a race" do
        before do
          get :toggle_status,{:id => @raced.id}
        end
        it {should respond_with(:redirect)      }
        it { should redirect_to(admin_races_path)  }
        it { should set_the_flash }
      end
    end




  end
  describe "SuperAdmin" do
    def logged_in_user
      invite = Fabricate(:invite,:role_id=>1)
      @user = Fabricate(:user, :email =>invite.email,:role_id=>invite.role_id)
    end
    include_examples "admin_races"
  end

  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite,:role_id=>2)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => invite.role_id})
    end
    include_examples "admin_races"
  end

end
