class UpdateNamesToInvites < ActiveRecord::Migration
  def up
  	Invite.all.each do |invite|
      invite.invitor_name = invite.user.full_name
      invite.medical_organization_name = invite.medical_organization.name
      invite.role_name = invite.role.name
      invite.save
    end
  end

  def down
  end
end
