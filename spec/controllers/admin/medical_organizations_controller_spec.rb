require 'spec_helper'

describe Admin::MedicalOrganizationsController do

  shared_examples_for "admins" do

    before do
      @medical_organization = Fabricate(:medical_organization)
      sign_in :user, logged_in_user
    end


    describe "List all medical organizations" do
      context "List active medical organizations" do
        before do
          @medical_organization = Fabricate(:medical_organization,:status=>true)
          get :index,{ :search=>{:status_is_true=>"active"}}
        end
        it { should respond_with(:success)            }
      end
      context "List suspended medical organizations" do
        before do
          @medical_organization = Fabricate(:medical_organization,:status=>false)
          get :index,{ :search=>{:status_is_true=>"suspend"}}
        end
        it { should respond_with(:success)            }
      end
      context "Listall medical organizations" do
        before do
          get :index,{:page => 1}
        end
        it { should respond_with(:success)            }
      end

    end

    context "Create new medical organization" do
      before do
        get :new
      end
      it { should respond_with(:success)            }
    end


    context "Edit a medical organization" do
      before do
        get :edit,{:id =>@medical_organization.id}
      end
      it { should respond_with(:success)            }
    end


    describe "POST create" do
      context "Valid attributes" do
        before do
          post :create, {:medical_organization => Fabricate.attributes_for(:medical_organization)}
        end
        it { should respond_with(:redirect)                                                }
        it { should redirect_to(admin_medical_organizations_path)                                }
        it { should set_the_flash[:notice].to('Medical organization created successfully.')}
      end
      context "Invalid attributes" do
        before do
          post :create, {:medical_organization => {} }
        end
        it { should respond_with(:success)                                                }
        it { should render_template(:new)                                                 }
        it { should render_with_layout(:application)                                      }
        it { should_not set_the_flash                                                     }
      end
    end



    describe "Update a medical organization" do
      context "Valid attributes" do
        before do
          put :update, {:id => @medical_organization.id, :medical_organization =>Fabricate.attributes_for(:medical_organization)}
        end
        it { should respond_with(:redirect)                                               }
        it { should redirect_to(admin_medical_organizations_path)     }
        it { should set_the_flash[:notice].to('Medical organization updated successfully.')         }
      end

      context "Invalid attributes" do
        before do
          put :update, {:id => @medical_organization.id, :medical_organization => {:name =>""}}
        end
        it { should respond_with(:success)                                                }
        it { should render_template(:edit)                                                }
      end

      context "should render error page" do
        before do
          put :update, {:id => "cpt", :medical_organization => {:name =>""}}
        end
        it { should respond_with(404) }
      end
    end

    describe "Change the status of medical organization"  do
      before do
        @medical_org = Fabricate(:medical_organization,:status =>true)
        invite = Fabricate(:invite,:role_id=>2)
        user = Fabricate(:user, :email => invite.email,:role_id=>invite.role_id)
        user.update_attribute(:medical_organization_id, @medical_org.id)
      end
      context "should be able to active or deactivate  a medical organization " do
        before do
          get :toggle_status,{:id =>@medical_organization.id}
        end
        it { should respond_with(:redirect)                  }
        it { should redirect_to(admin_medical_organizations_path)  }
        it { should set_the_flash }
      end
      context "should not be able to deactivate a medical organization" do
        before do
          get :toggle_status,{:id => @medical_org.id}
        end
        it {should respond_with(:redirect)      }
        it { should redirect_to(admin_medical_organizations_path)  }
        it { should set_the_flash }
      end
    end
  end
  describe "SuperAdmin" do
    def logged_in_user
      invite = Fabricate(:invite,:role_id=>1)
      @user = Fabricate(:user, :email =>invite.email,:role_id=>invite.role_id)
    end
    include_examples "admins"
  end

  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite,:role_id=>2)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => invite.role_id})
    end
    include_examples "admins"
  end
end
