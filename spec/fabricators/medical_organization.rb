Fabricator(:medical_organization) do
  name { sequence(:name) { |i| "name#{i}"}}
end

