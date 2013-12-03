class UpdateDefaultNamesToInvites < ActiveRecord::Migration
	def up
		invites = Invite.where(:invitor_name => nil, :medical_organization_name => nil, :role_name => nil)
		if invites.present?
			invites.each do |invite|
				invite.invitor_name = invite.user.full_name
				invite.medical_organization_name = invite.medical_organization.name
				invite.role_name = invite.role.name
			  invite.save(:validate=>false)
			end
		end
	end

	def down
	end
end
