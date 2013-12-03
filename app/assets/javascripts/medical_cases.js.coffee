# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if $(".tags_with_autocomplete").is(":visible") is true
    $('.tags_with_autocomplete').autocomplete
      minLength: 1
      source: (request, response) ->
        author = request.term
        $.ajax
          url: $('.tags_with_autocomplete').data('autocompleteurl')
          dataType: "json"
          data:
            name: author
          success: (data) ->
            response(data.slice(0,3));
  if $(".author_with_autocomplete").is(":visible") is true
    $('.author_with_autocomplete').autocomplete
      minLength: 1
      source: (request, response) ->
        author = request.term
        $.ajax
          url: $('.author_with_autocomplete').data('autocompleteurl')
          dataType: "json"
          data:
            name: author
          success: (data) ->
            response(data.slice(0,3));


$("#medical_cases").on "click", "a.status", ->
  record_id = $(this).attr("id")
  it = $(this);
  if $(this).children('i').hasClass("gray") is true
    $.ajax
      url: "/medical_cases/" + record_id + "/add" #your server side script
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
      url: "/medical_cases/" + record_id + "/remove" #your server side script
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


# Dynamic fileds
remove_fields = (link) ->
  $(link).prev("input[type=hidden]").val "1"
  $(link).closest(".fields").hide()
window.remove_fields = remove_fields
add_table_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  $("#" + association).append content.replace(regexp, new_id)
window.add_table_fields = add_table_fields

# Toggle funtion for all pages

$(".case_history h5").click ->
  txt = $(".case_history h5").text()
  if txt is "[+] History"
    $(".case_history h5").text "[-] History"
  else
    $(".case_history h5").text "[+] History"
  $(".history-list").slideToggle "slow"

$(".case_tags h5 span").click ->
  txt = $(this).text()
  if txt is "[+] Tags"
    $(this).text "[-] Tags"
  else
    $(this).text "[+] Tags"
  $(".tags-names").slideToggle "slow"


$(".case_comments h5 span").click ->
  txt = $(this).text()
  if txt is "[-] Comments"
    $(this).text "[+] Comments"
  else
    $(this).text "[-] Comments"
  $(".comment-list").slideToggle "slow"

$(".minus-tag").click ->
  txt = $(this).text()
  if txt is "[-]"
    $(this).text "[+]"
  else
    $(this).text "[-]"
  $(".toggle_tag_form").slideToggle()



# Comments required 
$(".comment_comment textarea").keyup ->
  $("#error").html ""
  $("#error-case").html ""


$(".accordion-heading, .accordion-heading-three, .accordion-heading-two").click ->
  setTimeout (->
    if $(".accordion .accordion-group:first .in").is(":visible")
      $(".accordion .accordion-group:first div a span").text "[-]"
    else
      $(".accordion .accordion-group:first div a span").text "[+]"
    if $(".accordion .accordion-group:last .in").is(":visible")
      $(".accordion .accordion-group:last div a span").text "[-]"
    else
      $(".accordion .accordion-group:last div a span").text "[+]"
  ), 50
