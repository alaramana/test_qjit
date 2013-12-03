require 'spec_helper'

describe Users::SessionsController do
  shared_examples_for "all_sessions_users" do
    before do
 	    @request.env['devise.mapping'] = Devise.mappings[:user];
      sign_in :user, logged_in_user
    end

    describe "Logout" do
      before do
        delete :destroy
      end
      it { should redirect_to(root_path)                }
    end
  end
  describe "SuperAdmin" do
    def logged_in_user
      invite = Fabricate(:invite)
      Fabricate(:user, :email =>invite.email,:session_sign_in_count=>15,:current_sign_in_at=>"2013-06-06 10:02:17",:sign_in_count=>3)
    end
    include_examples "all_sessions_users"
  end

  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite)
      Fabricate(:user, {:email =>invite.email,:role_id => 2,:session_sign_in_count=>15,:current_sign_in_at=>"2013-06-06 10:02:17",:sign_in_count=>3})
    end
    include_examples "all_sessions_users"
  end
	
  describe "User" do
    def logged_in_user
      invite = Fabricate(:invite)
      Fabricate(:user, {:email => invite.email,:role_id => 3,:session_sign_in_count=>15,:current_sign_in_at=>"2013-06-06 10:02:17",:sign_in_count=>3})
    end
    include_examples "all_sessions_users"
  end
end