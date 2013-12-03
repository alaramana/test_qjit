# == Schema Information
#
# Table name: medical_organizations
#
#  id          :integer          not null, primary key
#  name        :string(75)       not null
#  status      :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  users_count :integer          default(0)
#

require 'spec_helper'

describe MedicalOrganization do

  context "Mass-Assignments" do
    it { should allow_mass_assignment_of(:name)           }
    it { should_not allow_mass_assignment_of(:status)     }
    it { should_not allow_mass_assignment_of(:created_at) }
  end

  context "Trim trailing whitespaces" do
    it "should strip name" do
      school = MedicalOrganization.new(:name => " Sample Name ")
      school.valid?
      school.name.should match 'Sample Name'
    end
  end

  context "Associations" do
    it { should have_many(:users) }
  end

  context "Validations" do
    it { should validate_presence_of(:name)                    }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  context "Scope:order by name" do
    before do
      4.times.each do
        Fabricate(:medical_organization)
      end
    end

    it "should be ordered by name in ascending order" do
      records  = MedicalOrganization.order(:name).collect{|x| x.name}
      medicals = MedicalOrganization.all
      medicals.first.name.should match records.first
      medicals.last.name.should match records.last
    end
  end

  describe "Pagination" do
    before do
      25.times.each do
        Fabricate(:medical_organization)
      end
      @records = MedicalOrganization.all
    end

    context "First page" do
      before do
        @recs = MedicalOrganization.list(1)
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
        @recs = MedicalOrganization.list(2)
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

  context "Deletion" do
    before do
      @medical_organization = Fabricate(:medical_organization)
    end

    it "should not delete any records using delete method" do
      expect{ @medical_organization.delete }.to raise_error("delete method is disabled.")
    end

    it "should not delete any records using destroy method" do
      expect{ @medical_organization.destroy }.to raise_error("destroy method is disabled.")
    end

    it "should not allow group delete" do
      expect{ MedicalOrganization.delete_all }.to raise_error("delete_all method is disabled.")
    end

    it "should not allow group destroy" do
      expect{ MedicalOrganization.destroy_all }.to raise_error("destroy_all method is disabled.")
    end
  end

  context "#creation_date" do
    before do
      @school = Fabricate(:medical_organization)
    end

    it "should display created date in mmm dd, yyyy format" do
      @school.creation_date.should match @school.created_at.strftime("%b %d, %Y")
    end
  end

  context "#active_status" do
    before do
      @school = Fabricate(:medical_organization)
    end

    it "should display status as 'InActive'" do
      @school.active_status.should match 'Inactive'
    end

    it "should display status as 'Active'" do
      @school.update_attribute(:status, true)
      @school.active_status.should match 'Active'
    end
  end

  context "#total_members" do
    before do
      @school1 = Fabricate(:medical_organization)
      invite = Fabricate(:invite)
      invite.save

      user = User.new(Fabricate.attributes_for(:user, :email => invite.email,:role_id=>invite.role_id))
      user.medical_organization_id =  @school1.id
      user.save
    end

    it "should have 1 member" do
      @school1.total_members.should eq 1
    end
  end

  context "#deactivate" do
    before do
      @school1 = Fabricate(:medical_organization)
      invite = Fabricate(:invite)
      invite.invitation_token = Digest::SHA1.hexdigest(invite.email)
      invite.save

      user = Fabricate(:user, :email => invite.email,:role_id=>invite.role_id)
      user.update_attribute(:medical_organization_id, @school1.id)
      @school2 = Fabricate(:medical_organization)
      MedicalOrganization.update_all(:status => true)
    end

    it "should not allow deactivation when it has members" do
      @school1.deactivate.should be_false
      msg = "Cannot deactivate '#{@school1.name}'. It has one or more members."
      @school1.errors.full_messages.to_sentence.should include msg
    end

    it "should allow deactivation when it does not have any members" do
      @school2.deactivate.should be_true
    end
  end

  context "#activate" do
    before do
      @school1 = Fabricate(:medical_organization)
      invite = Fabricate(:invite)
      invite.invitation_token = Digest::SHA1.hexdigest(invite.email)
      invite.save

      user = Fabricate(:user, :email => invite.email,:role_id=>invite.role_id)
      user.update_attribute(:medical_organization_id, @school1.id)
      @school2 = Fabricate(:medical_organization)
    end

    it "should activate whether it may or may not have members" do
      @school1.activate.should be_true
      @school2.activate.should be_true
    end
  end

  context "#change_toggle_status" do
    before do
      @school = Fabricate(:medical_organization)
    end

    it "should set status as active" do
      @school.change_toggle_status
      @school.status.should be_true
    end
  end
end
