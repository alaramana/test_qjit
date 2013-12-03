# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  encrypted_password      :string(255)      default(""), not null
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0)
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  firstname               :string(40)       not null
#  lastname                :string(40)       not null
#  username                :string(255)
#  medical_organization_id :integer          not null
#  address1                :string(50)       not null
#  address2                :string(50)
#  city                    :string(50)       not null
#  state_id                :integer          not null
#  zip                     :string(10)       not null
#  phone                   :string(50)       not null
#  active                  :boolean          default(TRUE)
#  role_id                 :integer          default(0)
#  recent_session_time     :integer          default(0)
#  session_sign_in_count   :integer          default(0)
#  session_total_hours     :integer          default(0)
#  average_session_time    :integer          default(0)
#  forem_admin             :boolean          default(FALSE)
#  forem_state             :string(255)      default("pending_review")
#  forem_auto_subscribe    :boolean          default(FALSE)
#  belt                    :string(40)       default("white")
#

require 'spec_helper'

describe User do
   include UserHelper

  context "Mass-assignment" do
    it { should allow_mass_assignment_of(:firstname)                        }
    it { should allow_mass_assignment_of(:lastname)                         }
    it { should allow_mass_assignment_of(:email)                            }
    it { should allow_mass_assignment_of(:phone)                            }
    it { should allow_mass_assignment_of(:address1)                         }
    it { should allow_mass_assignment_of(:address2)                         }
    it { should allow_mass_assignment_of(:city)                             }
    it { should allow_mass_assignment_of(:state_id)                         }
    it { should allow_mass_assignment_of(:zip)                              }
    it { should allow_mass_assignment_of(:active)                           }
    it { should allow_mass_assignment_of(:medical_organization_id)          }
    it { should allow_mass_assignment_of(:password)                         }
    it { should allow_mass_assignment_of(:password_confirmation)            }
    it { should_not allow_mass_assignment_of(:created_at)                   }

  end

  context "Validations" do
    it { should validate_presence_of(:firstname)                            }
    it { should ensure_length_of(:firstname).is_at_most(40)                 }
    it { should allow_value("John Maxwel").for(:firstname)                  }
    it { should_not allow_value("John@Maxwel").for(:firstname)              }


    # it { should validate_presence_of(:address1)                             }
    # it { should ensure_length_of(:address1).is_at_most(50)                  }

    # it { should ensure_length_of(:address2).is_at_most(50)                  }

    # it { should validate_presence_of(:city)                                 }
    # it { should ensure_length_of(:city).is_at_most(50)                      }

    # it { should validate_presence_of(:state_id)                             }

    # it { should validate_presence_of(:zip)                                  }
    it { should ensure_length_of(:zip).is_at_most(10)                       }
    it { should allow_value("12341-1239").for(:zip)                         }

    it { should validate_presence_of(:email)                                }
    it { should ensure_length_of(:email).is_at_most(150)                    }
    it { should allow_value("jon@Example.co.in").for(:email)                }
    it { should allow_value("jon@Example.com").for(:email)                  }
    it { should_not allow_value("jonexample.com").for(:email)               }

    # it { should validate_presence_of(:phone)                                }
    it { should ensure_length_of(:phone).is_at_most(20)                     }
    it { should ensure_length_of(:phone).is_at_least(10)                    }
    it { should allow_value("(123) 455-6677").for(:phone)                   }
    it { should_not allow_value("1234556677.1").for(:phone)                 }

    it { should validate_presence_of(:password)                             }
    it { should validate_confirmation_of(:password)                         }
  end



  context "Associations" do
    it { should belong_to(:state)                                           }
    it { should belong_to(:role)                                            }
    it { should belong_to(:medical_organization)                            }
    it { should have_many(:invites).with_foreign_key(:invitor_id)           }
  end

  context "Trim trailing whitespaces" do
    it "should strip name" do
      user = User.new(:firstname => " SampleName ",
      :lastname=> " SampleName",
      :email=>" sample@example.com ",
      :username=>" UserName ",
      :password=> " password1223 ",
      :phone  => " 121211121 ",
      :address1=> " address1 ",
      :address2=> " address2 ",
      :city => " City Name ",
      :zip => " 1121 "
      )

      user.firstname.should match 'SampleName'
      user.lastname.should match 'SampleName'
      user.email.should match 'sample@example.com'
      user.username.should match 'UserName'
      user.password.should match 'password1223'
      user.phone.should match '121211121'
      user.address1.should match 'address1'
      user.address2.should match 'address2'
      user.city.should match 'City Name'
      user.zip.should match '1121'
    end
  end

  context "Scope:order by creation date" do
    before do
      4.times.each do
        invite = Fabricate(:invite)
        Fabricate(:user,:email =>invite.email,:role_id=>invite.role_id)
      end
    end

    it "should be ordered by name in ascending order" do
      records  = User.order(:created_at).collect{|x| x.created_at.to_s}
      users = User.all
      users.first.created_at.to_s.should match records.first
      users.last.created_at.to_s.should match records.last
    end
  end

  context "Methods" do
    before do
      invite = Fabricate(:invite)
      @user1 = Fabricate(:user,:email =>invite.email,:role_id=>invite.role_id)
    end
    it "FullName should contains first name and last name" do
      fullname= [@user1.firstname, @user1.lastname].join(" ")
      @user1.full_name.should eq(fullname)
    end

    it "created at date should be a join_date" do
      @user1.joined_date.should eq(@user1.created_at)
    end

    it "Should show only fullname when user called as string" do
      fullname= [@user1.firstname, @user1.lastname].join(" ")
      @user1.to_s.should eq(fullname)
    end

  end

  describe "Pagination"  do
    before do
      25.times.each do
        invite = Fabricate(:invite)
        Fabricate(:user,:email=>invite.email)
      end
      @records = User.all
    end

    context "First page" do
      before do
        @recs = User.list(1)
      end

      it "should return 15 records on first page" do
        @recs.should have(15).items
      end

      it "should include the first record" do
        @recs.should include @records.first
      end

      it "should include 15th record" do
        @recs.should include @records[14]
      end

      it "should not include 25th record" do
        @recs.should_not include @records.last
      end
    end

    context "Last page" do
      before do
        @recs = User.list(2)
      end

      it "should return 10 records on last page" do
        @recs.should have(10).items
      end

      it "should not include the first record" do
        @recs.should_not include @records.first
      end

      it "should include 16th record" do
        @recs.should include @records[15]
      end

      it "should include 25th record" do
        @recs.should include @records.last
      end
    end
  end

context "#invite_user" do
    before do
      @user1     = create_user_with_invitation
      @user2     = create_admin_with_invitation
      @user3     = create_superadmin
      @email     = Faker::Internet.email
      @role_id   = [2, 3].sample
      @school_id = Fabricate(:medical_organization).id
    end

    it "should allow admin to send invitation" do
      @user2.invite_user(@email, @role_id, @school_id).should be_true
    end

    it "should allow superadmin to send invitation" do
      @user3.invite_user(@email, @role_id, @school_id).should be_true
    end

    it "should not allow user to send invitation" do
      @user1.invite_user(@email, @role_id, @school_id).should be_false
    end


    it "should not allow a user to invite another user with admin privilege" do
      @user1.invite_user(@email, 1, @school_id).should be_false
    end
  end


  describe "modify the status of invite"  do
    it "should change the status " do
      invite = Fabricate(:invite)
      invite.status.should be_false
      user = Fabricate(:user,:email =>invite.email,:role_id=>invite.role_id)
      invt = Invite.find_by_email(user.email)
      invite.email.should eq invt.email
      invt.status.should be_true

    end
  end

  describe "set role" do
    it "should set the role to user" do
      invite = Fabricate(:invite)
      user = Fabricate(:user,:email =>invite.email,:role_id=>invite.role_id)
      invitaion = Invite.find_by_email(user.email)
      !invite.expired?
      user.role_id.should eq invitaion.role_id
    end
  end


  describe 'validates combined uniqueness of user and invite'  do
    it "should set user" do
      invite1 = Fabricate(:invite)
      user1 = Fabricate(:user,:email =>invite1.email,:role_id=>invite1.role_id)
      invite2 = Fabricate(:invite,:email =>"yourname@gmail.com",:role_id=>3)
      user1.update_attribute(:email, "yourname@gmail.com")
      user1.save.should raise_error
    end
  end



  describe " Methods" do
    before do
      @invite = Fabricate(:invite)
      @user =  Fabricate(:user,:email=>@invite.email)
    end

    context "Override delete, destroy, delete_all, destroy_all methods" do
      it "should not delete any records using delete and destroy" do
        User.count.should eq 1
        lambda {User.last.delete}.should raise_error(RuntimeError)
        lambda {User.first.destroy}.should raise_error(RuntimeError)
        User.count.should eq 1
      end
      it "should not delete any records using delete_all and destroy_all" do
        User.count.should eq 1
        lambda {User.destroy_all}.should raise_error(RuntimeError)
        User.count.should eq 1
      end
    end

    context "#full_name" do
      it "should add firstname and lastname" do
        @user.update_attributes(:firstname => "mith",:lastname =>"sachin")
        @user.full_name.should eq "mith sachin"
      end
    end

    context "#joined_date" do
      it "should show the created at date" do
        @user.update_attribute(:created_at,"2013-06-03 12:19:11")
        @user.joined_date.should eq "2013-06-03 12:19:11"
      end
    end

    context "#role_name" do
      it "should select the role of a user" do
        invite = Fabricate(:invite,:role_id=>2)
        user = Fabricate(:user,:email=>invite.email,:role_id=>invite.role_id)
        user.role_name.should eq "admin"
      end
    end
  end
end
