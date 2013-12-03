require 'spec_helper'
describe ApplicationController do
  shared_examples_for "all_users" do
    before do
      logged_in_user
      @user = User.first
      sign_in :user, @user
    end

    describe "GET some_get_method" do
      it "should work" do

        community_user = controller.forem_user.id
        current_user = @user.id
        community_user.should eq current_user
      end
    end
  end
  describe "SuperAdmin" do
    def logged_in_user
      Invite.delete_all
      # User.delete_all
      invite = Fabricate(:invite)
      Fabricate(:user, :email =>invite.email,:role_id => 2)
    end
    include_examples "all_users"
  end

  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 2})
    end
    include_examples "all_users"
  end
  describe "users" do
    def logged_in_user
      invite = Fabricate(:invite)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => 3})
    end
    include_examples "all_users"
  end

end