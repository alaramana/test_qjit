require 'spec_helper'

describe Devise::RegistrationsController do
  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @invite = Fabricate(:invite)
    @user = Fabricate(:user,:email =>@invite.email)
  end

  describe "User Registration" do
    context "Registration page" do
      before do
        invite = Fabricate(:invite)
        invite.updated_at = Time.now.utc - 7.days
        invite.save
        get :new,  {"invitation_token"=>invite.invitation_token}
      end
      it { should respond_with(:redirect)             }
      it { should redirect_to(root_path)              }
      it { should set_the_flash[:alert].to("Request expired, request a new one")}
    end

    context "with invalid invitation" do
      before do
        get :new, {},{}
      end
      it { should respond_with(:redirect)             }
    end

  end

  describe 'User signup' do
    context "with valid values" do
      before do
        post :create, {:user => Fabricate.attributes_for(:user,:email =>@invite.email)}, {}
      end
      it { should respond_with(:success) }
    end
    context "with invalid values" do
      before do
        post :create, {:user =>{}},{}
      end
      it {should respond_with(:success)}
    end
  end

end
