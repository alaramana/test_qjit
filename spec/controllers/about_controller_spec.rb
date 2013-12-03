require 'spec_helper'

describe AboutController do

	shared_examples_for "about_users" do
		before do
			@medical_case = Fabricate(:medical_case)
			sign_in :user, logged_in_user
		end

		describe "GET 'index'" do
			it "returns http success" do
				get 'index'
				response.should be_success
			end
		end
	end

	describe "SuperAdmin" do
		def logged_in_user
			invite = Fabricate(:invite)
			@user = Fabricate(:user, :email =>invite.email)
		end
		include_examples "about_users"
	end
	describe "Admin" do
		def logged_in_user
			invite = Fabricate(:invite)
			@user = Fabricate(:user, {:email =>invite.email,:role_id => 2})
		end
		include_examples "about_users"
	end
	describe "users" do
		def logged_in_user
			invite = Fabricate(:invite)
			@user = Fabricate(:user, {:email =>invite.email,:role_id => 3})
		end
		include_examples "about_users"
	end
end
