Fabricator(:exam_question) do
	question_prompt { sequence(:question_prompt) { |i| "question_prompt#{i}"}}
	correct_answer  "cpt"
	average_rating (1..5).to_a.sample
	creator_id   1
end