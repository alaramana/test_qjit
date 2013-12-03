Fabricator(:objective) do
  name { sequence(:name) { |i| "objective_name#{i}"}}
  start_date  Time.now+1.day
  end_date    Time.now+1.month
end

