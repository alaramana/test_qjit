require 'spec_helper'

describe Admin::UsersController do

  shared_examples_for "admin_users" do
    before do
      sign_in :user, logged_in_user
    end
    describe "List users" do
      context "List all users" do
        before do
          get :index, {:page => 1}
        end
        it { @user.stub!(:current_page).and_return(1)}
        it { @user.stub!(:num_pages).and_return(1) }
        it { @user.stub!(:limit_value).and_return(1) }
        it { should respond_with(:success)            }
        it { should render_template(:index)           }
        it { should render_with_layout(:application)  }
      end

      context "list active users" do
        before do
          4.times do
            invite = Fabricate(:invite)
            @user = Fabricate(:user, :email =>invite.email,:active=>true)
          end
          get :index,{ :search=>{:active_is_true=>"active"}}
        end
        it { should respond_with(:success)            }
      end

      context "list suspended users" do
        before do
          4.times do
            invite = Fabricate(:invite)
            @user = Fabricate(:user, :email =>invite.email,:active=>false)
            get :index,{ :search=>{:active_is_true=>"suspend"}}
          end
        end
        it { should respond_with(:success)            }
      end

    end

    context "Edit a user" do
      before do
        get :edit,{:id =>@user.id}
      end
      it { should respond_with(:success)            }
    end

    describe "PUT update" do
      context "Valid attributes" do
        before do
          invite = Fabricate(:invite)
          put :update, {:id => @user.id, :user =>Fabricate.attributes_for(:user,:email=>"yourname@gmail.com",:role_id=>invite.role_id)}
        end
        it { should respond_with(:redirect)                                               }
        it { should redirect_to(admin_users_path)     }
        it { should set_the_flash[:notice].to('User updated successfully')         }
      end

      context "Invalid attributes" do
        before do
          put :update, {:id =>@user.id, :user =>Fabricate.attributes_for(:user,:email=>"cpt") }
        end
        it { should respond_with(:success)                }
        it { should render_template("admin/users/edit")   }
        it { should render_with_layout(:application)}
      end
    end


    context "Activate or In-activate user" do
      before do
        get :toggle_status,{:user_id =>@user.id, :active =>!@user.active}
      end
      it { should respond_with(:redirect)                  }
      it { should redirect_to(admin_users_path)  }
      it { should set_the_flash }
    end

    describe "send invitation to user" do
      context "with Valid parameters" do
        before do
          @org = Fabricate(:medical_organization)
          @role = Fabricate(:role)
          @invite = Fabricate(:invite,:role_id=>@role.id,:medical_organization_id=>@org.id)
          post :send_invite, {"invite"=>{"email"=>"aslkdfj@g.com", "medical_organization_id"=>"1", "role_id"=>"1"}}
          # controller.should_receive(invite_user(logged_in_user))
          #  UserMailer.should_receive(:send_user_invitation).with(an_instance_of(Invite))
        end
        it {should respond_with(:redirect)}
        it { should redirect_to("/admin/users/invitations")}
        it { should set_the_flash.to("Invitation has been sent to aslkdfj@g.com.")}
      end

      context "with Invalid parameters" do
        before do
          post :send_invite, {:invite =>{:email =>"cpt", :role_id =>2 }}
        end
        it {should respond_with(:redirect)}
        it { should redirect_to("/admin/users/invitations")}
      end
    end

    context "Resend invitation to user/admin" do
      before do
        @invite = Fabricate(:invite)
        get :resend_invite, {:invite => {:id =>@invite.id} }
      end
      it {should respond_with(:redirect)}
      it { should redirect_to(invitations_admin_users_path)}
      it { should set_the_flash.to("Invitation has been sent to #{@invite.email}.")}
    end

    describe "List invitations" do
      context "List all invitations" do
        before do
          @invite = Fabricate(:invite)
          get :invitations, {:page => 1}
        end
        it { @invite.stub!(:current_page).and_return(1)}
        it { @invite.stub!(:num_pages).and_return(1) }
        it { @invite.stub!(:limit_value).and_return(1) }
        it { should respond_with(:success)            }
        it { should render_template("admin/users/invitations")}
        it { should render_with_layout(:application)  }
      end

      context "list joined invitations" do
        before do
          @invite = Fabricate(:invite,:status=>true)
          get :invitations,{ :search=>{:status_is_true=>"joined"}}
        end
        it { should respond_with(:success)            }
      end

      context "list joined invitations" do
        before do
          @invite = Fabricate(:invite,:status=>true)
          get :remove_pending_invitaion,{"invite_id"=>@invite.id}
        end
        it { should respond_with(:redirect)            }
      end


      context "list pending invitations" do
        before do
          @invite = Fabricate(:invite,:status=>false)
          get :invitations,{ :search=>{:status_is_true=>"pending"}}
        end
        it { should respond_with(:success)            }
      end

      context "list joined and sorted invitations with email" do
        before do
          @invite = Fabricate(:invite,:status=>true)
          get :invitations,{"search"=>{"status_is_true"=>"joined"}, "sort"=>"email"}
        end
        it { should respond_with(:success)            }
      end

      context "list pending and sorted invitations with email" do
        before do
          @invite = Fabricate(:invite,:status=>false)
          get :invitations,{"search"=>{"status_is_true"=>"pending"}, "sort"=>"email"}
        end
        it { should respond_with(:success)            }
      end

      context "list sorted invitations with email" do
        before do
          @invite = Fabricate(:invite,:status=>false)
          get :invitations,{"sort"=>"email"}
        end
        it { should respond_with(:success)            }
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
      it { should render_template("admin/users/user_cases")}
      it { should render_with_layout(:application)  }
    end
  end

  describe "SuperAdmin" do
    def logged_in_user
      invite = Fabricate(:invite,:role_id=>1)
      @user = Fabricate(:user, :email =>invite.email,:role_id=>invite.role_id)
    end
    include_examples "admin_users"
  end

  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite,:role_id=>2)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => invite.role_id})
    end
    include_examples "admin_users"
  end
end
