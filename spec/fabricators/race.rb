Fabricator(:race) do
  name { sequence(:name) { |i| "race_name#{i}"}}
end

