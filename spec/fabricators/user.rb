Fabricator(:user) do
  email                      { sequence(:email) { |i| "user#{i}@example.com" } }
  password                   "password"
  password_confirmation      "password"
  username                   { sequence(:username) { |i| "username#{i}"}}
  firstname                  Faker::Name.first_name
  lastname                   Faker::Name.last_name
  medical_organization_id    1
  active                     true
  address1                   Faker::Address.secondary_address
  address2                   Faker::Address.street_address
  city                       Faker::Address.city
  state_id                   (1..40).to_a.sample
  zip                        "12345-6789"
  phone                      (8885554440..8885554540).to_a.sample
end
