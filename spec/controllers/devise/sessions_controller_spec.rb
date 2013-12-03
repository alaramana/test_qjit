require "spec_helper"
describe Devise::SessionsController do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user];
    @invite = Fabricate(:invite)
    @user = Fabricate(:user,:email =>@invite.email)
  end

  context "login" do
    before do
      post :create,{ :user => {:email =>@user.email, :password =>@user.password }}, {}
    end
    it { should redirect_to("/exam_questions")                }
  end


  context "Logout" do
    before do
      delete :destroy, {}, {}
    end
    it { should redirect_to(root_path)                }
  end

  describe "Invalid attributes" do
    context "without  email and password" do
      before do
        post :create, {:user =>{} }, {}
      end
      it { should respond_with(:success)                }
      it { should render_template(:new)                 }
    end


    context "invalid email and valid password" do
      before do
        post :create, {:email =>"raja@gmail.co", :password =>@user.password }, {}
      end
      it { should respond_with(:success)                }
      it { should render_template(:new) }
    end

    context "valid email and invalid password" do
      before do
        post :create, {:email =>@user.email, :password =>"asdfsa" }, {}
      end
      it { should respond_with(:success)                }
      it { should render_template(:new)                 }
    end

    context "email and without password" do
      before do
        post :create, {:email =>@user.email, :password =>"" }, {}
      end
      it { should respond_with(:success)                }
      it { should render_template(:new)                 }
    end

    context "password and without email" do
      before do
        post :create, {:email =>"", :password =>@user.password }, {}
      end
      it { should respond_with(:success)                }
      it { should render_template(:new)                 }
    end
  end
end





