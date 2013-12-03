$(document).on "click", ".list-question", ->
  id = $(this).attr("id")
  from = $(this).attr("from")
  to = $(this).attr("to")
  obj = $(this).attr("obj")
  $.ajax
    type: "GET"
    url: "/admin/reports/questions?user_id=" + id + "&from=" + from + "&to=" + to + "+&obj=" + obj
    success: (data) ->
      list = []
      $.each data, (index, value) ->
        list.push "<p>" + (index + 1) + ": " + value + "</p></hr>"
      $("#question-prompts").html list
      $("#myModal").modal "show"


$(".buttontray form").on "submit", ->
  v = $(".buttontray form input[type='text'], select")
  total = []
  v.each (index, value) ->
    total.push $(value).val().length    
  sum = eval(total.join("+"))    
  question_from = new Date($("#search_filter_exam_questions_created_at_gte").val())
  question_to = new Date($("#search_filter_exam_questions_created_at_lte").val())
  comment_from = new Date($("#search_filter_comments_created_at_gte").val())
  comment_to = new Date($("#search_filter_comments_created_at_lte").val())
  rating_from = new Date($("#search_filter_ratings_created_at_gte").val())
  rating_to = new Date($("#search_filter_ratings_created_at_lte").val())
  if question_from > question_to
    alert "Questions Start date should be less than end date!"
    return false
  if comment_from > comment_to
    alert "Comments Start date should be less than end date!"
    return false
  if rating_from > rating_to
    alert "Ratings Start date should be less than end date!"
    return false
  false  if sum is 0
