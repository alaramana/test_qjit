Fabricator(:rating) do
	user_id         1
	medical_case_id (1..2).to_a.sample
	rate            (1..5).to_a.sample
end