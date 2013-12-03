require 'spec_helper'

describe Admin::ReportsController do

  shared_examples_for "admins_reports" do
    before do
      sign_in :user, logged_in_user
    end

    context "List all users session information" do
      before do
        get :index, {}
      end
      it { should respond_with(:success)            }
      it { should render_template(:index)           }
      it { should render_with_layout(:application)  }
    end

    context "List all users session information" do
      before do
        get :user_submitted_cases, {"page"=>"1", "sort"=>"firstname"}
      end
      it { should respond_with(:success)            }
      it { should render_template("admin/reports/user_submitted_cases")           }
      it { should render_with_layout(:application)  }
    end

    context "List all users session information" do
      before do
        get :user_submitted_cases, {}
      end
      it { should respond_with(:success)            }
      it { should render_template("admin/reports/user_submitted_cases")           }
      it { should render_with_layout(:application)  }
    end

   context "List all users session information" do
      before do
        get :user_submitted_cases, {"search_filter"=>{"name"=>"draring@escalation-point.com"}}
      end
      it { should respond_with(:success)            }
      it { should render_template("admin/reports/user_submitted_cases")           }
      it { should render_with_layout(:application)  }
    end

    context "List all users session information" do
      before do
        org = Fabricate(:medical_organization)
        get :user_submitted_cases, {"search_filter"=>{"medical_organization_id_in"=>org.id}}
      end
      it { should respond_with(:success)            }
      it { should render_template("admin/reports/user_submitted_cases")           }
      it { should render_with_layout(:application)  }
    end





     context "List all users session information" do
      before do
        get :user_test, {}
      end
      it { should respond_with(:success)            }
      it { should render_template("admin/reports/user_test")           }
      it { should render_with_layout(:application)  }
    end


    context "List all users session information" do
      before do
        get :user_aggregate, {}
      end
      it { should respond_with(:success)            }
      it { should render_template("admin/reports/user_aggregate")           }
      it { should render_with_layout(:application)  }
    end

    context "List all user questions" do
      before do
        invite = Fabricate(:invite,:role_id=>2)
        user = Fabricate(:user, {:email =>invite.email,:role_id => invite.role_id})
        exam_question = Fabricate(:exam_question,:creator_id => user.id)
        get :questions,{:user_id =>user.id}
      end
      it { should respond_with(:success)            }
    end
  end

  describe "SuperAdmin" do
    def logged_in_user
      invite = Fabricate(:invite,:role_id=>1)
      @user = Fabricate(:user, :email =>invite.email,:role_id=>invite.role_id)
    end
    include_examples "admins_reports"
  end

  describe "Admin" do
    def logged_in_user
      invite = Fabricate(:invite,:role_id=>2)
      @user = Fabricate(:user, {:email =>invite.email,:role_id => invite.role_id})
    end
    include_examples "admins_reports"
  end
end
