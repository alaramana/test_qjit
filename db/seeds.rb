# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.find_or_create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.find_or_create(name: 'Emanuel', city: cities.first)

['superadmin','admin','user'].each do |role|
  Role.find_or_create_by_name(:name => role)
end
puts 'Created roles'

states =
 [["Alabama","AL"],
  ["Alaska","AK"],
  ["Arizona","AZ"],
  ["Arkansas","AR"],
  ["California","CA"],
  ["Colorado","CO"],
  ["Delaware","DE"],
  ["Florida","FL"],
  ["Georgia","GA"],
  ["Hawaii","HI"],
  ["Idaho","ID"],
  ["Illinois","IL"],
  ["Indiana","IN"],
  ["Iowa","IA"],
  ["Kansas","KS"],
  ["Kentucky","KY"],
  ["Louisiana","LA"],
  ["Maine","ME"],
  ["Maryland","MD"],
  ["Massachusetts","MA"],
  ["Michigan","MI"],
  ["Minnesota","MN"],
  ["Mississippi","MS"],
  ["Missouri","MO"],
  ["Montana","MT"],
  ["Nebraska","NE"],
  ["New Hampshire","NH"],
  ["New Jersey","NJ"],
  ["New Mexico","NM"],
  ["New York","NY"],
  ["North Carolina","NC"],
  ["North Dakota","ND"],
  ["Ohio","OH"],
  ["Oklahoma","OK"],
  ["Oregon","OR"],
  ["Pennsylvania","PA"],
  ["Rhode Island","RI"],
  ["South Carolina","SC"],
  ["South Dakota","SD"],
  ["Tennessee","TN"],
  ["Texas","TX"],
  ["Utah","UT"],
  ["Vermont","VT"],
  ["Virginia","VA"],
  ["Washington","WA"],
  ["West Virginia","WV"],
  ["Wisconsin","WI"],
  ["Wyoming","WY"],
  ["Puerto Rico", "PR"]
]

states.each do |s|
  State.find_or_create_by_name(:name => s[0], :code => s[1])
end
puts 'Created states list'

medical_organization = MedicalOrganization.find_or_initialize_by_name({:name => "Qjitsu Inc"})
medical_organization.status = true
medical_organization.save
puts "Created a medical organization"

objective = Objective.find_or_initialize_by_name({:name => "C123 Physiology Fall 2013"})
objective.status = true
objective.save
puts "Created a Assignment"

race = Race.find_or_initialize_by_name({:name => "White"})
race.status = true
race.save
puts "Created a race"

superadmin = User.find_or_initialize_by_username_and_email({
              :username  => 'draring@escalation-point.com',
              :email     => 'draring@escalation-point.com',
              :password  => 'Qs1cf^hK@%!L*CL6S',
              :password_confirmation => 'Qs1cf^hK@%!L*CL6S',
              :firstname => "Dave",
              :lastname  => "Raring",
              :medical_organization_id => 1,
              :address1  => "Address 1",
              :city      => "City name",
              :state_id  => 1,
              :zip       => '60023-1234',
              :phone     => '111111111111',
              :belt      => 'white'
            })
superadmin.role_id = 1
superadmin.forem_admin = true
superadmin.forem_state = "approved"
superadmin.save
puts 'Created super admin with default password'

usernames = [ 'Albert', 'Betty', 'Carol', 'Duke', 'Egbert', 'Fred', 'Gilbert', 'Henry', 'Ibanez', 'Jackson', 'Kelly', 'Louis', 'McBride', 'Nelson', 'Oliver', 'Perry', 'Quincy', 'Robert', 'Shawn', 'Tully', 'Ucifer', 'Vincent', 'Wilbert', 'Xena', 'Yin', 'Zania' ]
usernames.each do |name|
	invite = Invite.find_or_initialize_by_email({
		:email => name.downcase+'@nowhere.com',
	  :role_id   => 3,
    :medical_organization_id => 1
	})
    invite.medical_organization_name = "FAKE"
	invite.role_name = "user"
	invite.invitor_id = 1
	invite.invitor_name = "dave"
	invite.status = true
	invite.save

	user = User.find_or_initialize_by_username_and_email({
    :username  => name.downcase,
    :email     => name.downcase+'@nowhere.com',
    :password  => name+'1234',
    :password_confirmation => name+'1234',
    :firstname => name,
    :lastname  => name,
    :medical_organization_id => 1,
    :address1  => "Address 1",
    :city      => "City name",
    :state_id  => 1,
    :zip       => '60023-1234',
    :phone     => '111111111111',
    :belt      => 'white',
	  :role_id   => 3
	})
	user.save

end
puts 'Created a bunch of users'

