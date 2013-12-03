Fabricator(:comment) do
  title { sequence(:title) { |i| "title#{i}" } }
  comment { sequence(:comment) { |i| "comment#{i}" } }
end