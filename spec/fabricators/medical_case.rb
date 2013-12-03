Fabricator(:medical_case) do
	title { sequence(:title) { |i| "medical_case_title#{i}"}}
	age    (10..60).to_a.sample
	average_rating (1..5).to_a.sample
	creator_id   1
	status "approved"
end