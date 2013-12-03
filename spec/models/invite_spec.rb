# == Schema Information
#
# Table name: invites
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  role_id                 :integer
#  invitation_token        :string(255)
#  status                  :boolean          default(FALSE)
#  invitor_id              :integer
#  medical_organization_id :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'spec_helper'
describe Invite do
	include UserHelper

	context "Mass-assignment" do
		it { should allow_mass_assignment_of(:email) }
		it { should allow_mass_assignment_of(:role_id) }
		it { should_not allow_mass_assignment_of(:invitation_token) }
		it { should_not allow_mass_assignment_of(:status) }
		it { should_not allow_mass_assignment_of(:invitor_id) }
	end

	context "Validations" do
		it { should validate_presence_of(:email) 																}
		it { should ensure_length_of(:email).is_at_most(150) 										}
	end

	describe "Pagination" do
		before do
			20.times.each do
				@invite=Fabricate(:invite)
			end
		end

		it "pagination per page should have 15 records" do
			records = Invite.order(:email)
			recs = Invite.list(1)
			recs.should include records.first
			recs.count.should eq 15

			recs = Invite.list(2)
			recs.should_not include records.first
			recs.count.should eq 5
		end

		it 'validates combined uniqueness of user and invite'  do
			invite = Fabricate(:invite,:role_id=>2)
			user = Fabricate(:user, :email => invite.email,:role_id=>invite.role_id)
			user.update_attribute(:email, "yourname@gmail.com")
			user.save
			invite1 = Invite.new(:email =>"yourname@gmail.com",:medical_organization_id =>1)
			invite1.invitor_id = 1
			invite1.save.should raise_error
		end
	end


	context "#send_mail" do
		before do
			@invite = Fabricate(:invite)
			@user2     = create_admin_with_invitation
		end

		it "should allow admin to send invitation mail" do
			@invite.send_mail(@user2).should be_true
		end

	end

end
