require 'spec_helper'
describe Ability do

    context "Super Admin" do
        it "Super admin is allowed to access all actions" do
            invite = Fabricate(:invite)
            user = Fabricate(:user,:email=>invite.email,:role_id=>1)
            ability = Ability.new(user)
            ability.should be_able_to(:destroy, user)
            ability.should be_able_to(:create, user)
            ability.should be_able_to(:update, user)
            ability.should be_able_to(:edit, user)
            ability.should be_able_to(:new, user)
        end
    end

    context "Admin" do
        it "admin is allowed to access all actions" do
            invite = Fabricate(:invite,:role_id=>2)
            user = Fabricate(:user,:email =>invite.email,:role_id=>invite.role_id)
            ability = Ability.new(user)
            ability.should be_able_to(:destroy, user)
            ability.should be_able_to(:create, user)
            ability.should be_able_to(:update, user)
            ability.should be_able_to(:edit, user)
            ability.should be_able_to(:new, user)
        end
    end

    context "user" do
        it "user can only read all users" do
            invite = Fabricate(:invite)
            user = Fabricate(:user,:email =>invite.email,:role_id=>3)
            ability = Ability.new(user)
            # ability.should be_able_to(:read, user)
            # ability.should be_able_to(:read, Fabricate(:medical_organization))
            ability.should_not be_able_to(:destroy, user)
            ability.should_not be_able_to(:create, user)
            ability.should_not be_able_to(:update, user)
            ability.should_not be_able_to(:edit, user)
            ability.should_not be_able_to(:new, user)

            ability.should_not be_able_to(:destroy, Fabricate(:medical_organization))
            ability.should_not be_able_to(:create, Fabricate(:medical_organization))
            ability.should_not be_able_to(:update, Fabricate(:medical_organization))
            ability.should_not be_able_to(:edit, Fabricate(:medical_organization))
            ability.should_not be_able_to(:new, Fabricate(:medical_organization))
        end
    end
end