Fabricator(:invite) do
	email             { sequence(:email) { |i| "user#{i}@example.com" } }
	invitation_token  { SecureRandom.urlsafe_base64  }
	status           false
	role_id          3
	invitor_id       1
	medical_organization_id 1
end