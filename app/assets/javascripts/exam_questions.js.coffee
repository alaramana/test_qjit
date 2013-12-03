# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#exam_questions").on "click", "a.status", ->
    record_id = $(this).attr("id")
    it = $(this);
    if $(this).children('i').hasClass("gray") is true
      $.ajax
        url: "/exam_questions/" + record_id + "/add" #your server side script
        data:
          qid: record_id
        type: "POST"
        success: (data) ->
          $(it).children('i').removeClass "gray"
          $(it).attr("title", "Remove favorite")
        error: (jxhr, msg, err) ->
      return false
    else
      $.ajax
        url: "/exam_questions/" + record_id + "/remove" #your server side script
        data:
          qid: record_id
        type: "POST"
        success: (data) ->
          $(it).children('i').addClass "gray"
          $(it).attr("title", "Add favorite")
          $('#no_id').click()
          if $('#search_favorites_is_active_is_true').is(':checked')==true
            $('.filter_forms').submit()
        error: (jxhr, msg, err) ->
      return false

  # exam questions ratings
  $(".rateit5").bind "rated", (event, value) ->
    productID = $(@).attr "name"
    is_question = $(@).attr "id"            
    rate_url = "/medical_cases/ratings" if is_question is "mcase_rate"
    rate_url = "/exam_questions/ratings"  if is_question is "question_rate"
    $.ajax
      url: rate_url #your server side script url
      data:
        idBox: productID
        rate: value
      type: "POST"
      success: (data) ->
      error: (jxhr, msg, err) ->

  #default funtion  
  $("#cookie-message").show()  if navigator.cookieEnabled is false
  $(".exam_mode").show()
  $(".fancybox").fancybox()
  $("#myLightbox").lightbox "resizeToFit"


  ## Filter funtions both exam questions and Medical cases page ##

  author = $("#search_user_firstname").val()
  $("#_order").change ->
    order = $(".order_field").val()
    tag = $(".tag_field").val()
    
    #exam questions order
    unless order is `undefined`
      name = $(this).val()
      if order.length > 0
        $(".order_field").attr "value", name
        removeAuthor()
        $(".filter_forms").submit()
    else unless tag is `undefined`
      name = $(this).val()
      if tag.length > 0
        $(".tag_field").attr "value", name
        removeAuthor()
        $("form#tags_form").submit()
    else
      removeAuthor()
      $(".order_form").submit()
  
  #medical case search  append value
  $("#exam_question_search, #medical_case_search").submit ->
    name = $("#_order").val()
    v = $("#searchinput").val()
    $(".order_field").attr "value", name
    $("#searchinputvalue").val v
    removeAuthor()
    $(".filter_forms").submit()
    false
  
  #Tags filter
  $("form#tags_form").submit ->
    name = $("#taginput").val()
    pre = $("#tag_name").val()
    tag_value = pre + "," + name
    $("#tag_name").val tag_value
    removeAuthor()
    $(".filter_forms").submit()
    false
  
  # Remove tag and filter  
  $("span.icon-remove").click ->
    tag = $(this).closest(".value").text()
    tags = []
    $(".remove_tag").parents(".labels a").each (index, value) ->
      name = $(value).text()
      tags.push name  unless tag is name
  
    $("#tag_name").val tags
    $(this).closest(".value").remove()
    removeAuthor()
    $(".filter_forms").submit()
    false
  
  # checbox filter search
  $("#search_favorites_is_active_is_true, #search_score_boards_correct_is_true,#not_answer, #search_score_boards_correct_is_false").click ->
    removeAuthor()
    $(this).closest("form").submit()
  
  # drop down filter search
  $("#search_status_contains, #search_status_is_true, #search_average_rating_greater_than, #search_ratings_rate_greater_than, #search_objective_name_contains, #search_active_is_true").change ->
    removeAuthor()
    $(this).closest("form").submit()
  
  #choose answer in questions
  $("#new_score_board").submit ->
    if $("input").is(":checked") is false
      $("#myModal").modal()
      false
      
 
  #DateTime picker select
  date = new Date()
  date.setDate date.getDate()
  $(".objective-form .input-append.date").datetimepicker
    autoclose: true    
    startDate: date
    pickSeconds: false
    pick12HourFormat: true

  $(".report-filter .datetimepicker").datetimepicker
    autoclose: true    
    pickSeconds: false
    pick12HourFormat: true
    endDate: date
    todayHighlight: true

# remove funtions required for IE filters
removeAuthor = ->
  author = $("#search_user_firstname").val()
  search = $("#searchinput").val()
  $("#search_user_firstname").val ""  if author is "enter author"
  $("#searchinput").val ""  if search is "Search Cases"
window.removeAuthor = removeAuthor



#Question / medical case edit required funtions
$(document).on "click", ".edit_wizard, .edit_question", ->
  $(".case-form #make-case").html ""
  id = $(this).attr("id")
  #  Set URL
  if $(this).hasClass("edit_question") 
    name = 'exam question'
    edit_form = "/exam_questions/" + id + "/edit"
  else
    name = 'medical case'
    edit_form = "/medical_cases/" + id + "/edit"
  $.ajax
    type: "GET"
    url: edit_form
    success: (data) ->
      $(".case-form #make-case").html data
      $(".case-form").show()
      $("#make-case").modal "show"
      $(".case-form .modal-header h3").text('Edit '+ name)
      $('#make-case ul.nav-tabs li').addClass('enable')
      $('#make-case a.btn-success').removeClass('disabled')
      popoverremove()
      openWiz()      
      editTags()

#Question / medical case creation required funtions
$(document).on "click", "#mcase, #create-question", ->
  $(".case-form #make-case").html ""
  filter = $(this).attr("name")
  form = $(this).attr("id")  
  #  Set URL
  new_form = "/exam_questions/new" if form is "create-question"
  new_form = "/medical_cases/new" if form is "mcase"
  $.ajax
    type: "GET"
    url: new_form
    success: (data) ->
      $(".case-form #make-case").html data
      $(".case-form").show()             
      $("#make-case").modal "show"
      openWiz()
      popoverremove()
      editTags()
      $("#filter_results").val filter



#Submit model form
submitModelForm = ->
  if $(".btn-success").hasClass("disabled") is true
    false
  else
    $("form.medical_case_form, form.exam_question_form").submit()
window.submitModelForm = submitModelForm

#Default
defaultsModel = ->
  $.fn.modal.defaults.maxHeight = ->
    # subtract the height of the modal header and footer
    $(window).height() - 165    
window.defaultsModel = defaultsModel

clearMessage = ->  
  if $("form#new_medical_case input[type=\"text\"], form#new_medical_case textarea, form#new_medical_case select ").is(":visible") is true
    $("form#new_medical_case input[type=\"text\"], form#new_medical_case textarea, form#new_medical_case select ").focus ->
      $(this).next().remove()

    true
  else if $("form#new_exam_question input[type=\"text\"], form#new_exam_question textarea, form#new_exam_question select ").is(":visible") is true
    $("form#new_exam_question input[type=\"text\"], form#new_exam_question textarea, form#new_exam_question select ").focus ->
      $(this).next().remove()

    true
window.clearMessage = clearMessage


$(document).on "click", ".icon-comment", ->
  id = $(@).attr("id")  
  name = $(@).attr('name')
  comemnts_url = "/exam_questions/get_comments?id=" + id if name is "question" 
  comemnts_url = "/medical_cases/get_comments?id=" + id if name is "mcase" 

  name = 
  $.ajax
    type: "GET"
    url: comemnts_url
    success: (data) ->
      $(".comemnt_form #comemnts").html data
      $(".comemnt_form").show()
      $("#comemnts").modal "show"

$(document).on "click", ".icon-tag", ->
  id = $(@).attr("id")  
  name = $(@).attr('name')
  
  tags_url = "/exam_questions/get_tags?id=" + id if name is "question"
  tags_url = "/medical_cases/get_tags?id=" + id if name is "mcase"
  $.ajax
    type: "GET"
    url: tags_url
    success: (data) ->
      $(".tags_form #tags").html data
      $(".tags_form").show()
      $("#tags").modal "show"      