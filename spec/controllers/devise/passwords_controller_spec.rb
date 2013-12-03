require "spec_helper"
describe Devise::PasswordsController do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user];
    @invite = Fabricate(:invite)
    @user = Fabricate(:user,:email =>@invite.email)
  end


  describe "Request new password" do

    context "GET new" do
      before { get :new, {}, {} }
      it { should respond_with(:success)                }
      it { should render_template(:new)                 }
    end


    context "User can able to request new password with valid email" do
      before do
        post :create,{ :user => {:email =>"@user.email"}}, {}
      end
      it { should render_template("devise/passwords/new") }
      it { should render_with_layout('login')  }
    end


    context "User can't able to request new password with invalid email" do
      before do
        post :create, {:email =>"cpta@gmail.com"}, {}
      end
    end

    context "GET edit" do
      before do
        @user.reset_password_token = SecureRandom.urlsafe_base64
        @user.save
        get :edit, {:reset_password_token => @user.reset_password_token}, {}
      end
      it { should respond_with(:success)                }
      it { should render_template(:edit)                }
    end

    describe "Update Password" do
      context "Valid attributes" do
        before do
          @user.reset_password_token   = SecureRandom.urlsafe_base64
          @user.reset_password_sent_at = Time.now
          @user.active = true
          @user.save
          put :update, {
          :user => {:reset_password_token => @user.reset_password_token,:password => 'password', :password_confirmation => 'password'} }, {}
        end
        it { should respond_with(:redirect)                      }
        it { should redirect_to("/exam_questions")         }
      end

      context "Invalid attributes" do
        before do
          @user.reset_password_token   = SecureRandom.urlsafe_base64
          @user.reset_password_sent_at = Time.now
          @user.save
          put :update, {
          :user => {:reset_password_token => @user.reset_password_token,:password => 'password', :password_confirmation => 'passw'} }, {}
        end
        it { should respond_with(:success)                      }
        it { should render_template(:edit)                      }
      end
    end

  end
end





