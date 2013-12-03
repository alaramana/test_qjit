popoverremove = ->
  #Case removal
  $(".medical_case_title input").keypress ->
    $(".medical_case_title .popover").remove()
  $(".medical_case_age input").keypress ->
    $(".medical_case_age .popover").remove()
  $(".medical_case_gender select").change ->
    $(".medical_case_gender .popover").remove()
  $(".medical_case_race select").change ->
    $(".medical_case_race .popover").remove()
  $(".medical_case_chief_complaint textarea").keypress ->
    $(".medical_case_chief_complaint .popover").remove()
  $(".medical_case_history_of_present_illness textarea").keypress ->
    $(".medical_case_history_of_present_illness .popover").remove()

  # Questions removal
  $(".exam_question_question_prompt textarea").on "keypress focus", ->
    $(".exam_question_question_prompt .popover").remove()
  $(".exam_question_correct_answer input").on "keypress focus", ->
    $(".exam_question_correct_answer .popover").remove()
  $(".exam_question_incorrect_1 input").on "keypress focus", ->
    $(".exam_question_incorrect_1 .popover").remove()
  $("#exam_question_incorrect_answers_attributes_0_answer").on "keypress focus", ->
    $("#row2 .exam_question_incorrect_answers_answer .popover").remove()
  $("#exam_question_incorrect_answers_attributes_1_answer").on "keypress focus", ->
    $("#row3 .exam_question_incorrect_answers_answer .popover").remove()
  $("#exam_question_incorrect_answers_attributes_2_answer").on "keypress focus", ->
    $("#row4 .exam_question_incorrect_answers_answer .popover").remove()

window.popoverremove  = popoverremove
 

tabs = ->
  $("li.disabled, li.active, li.answertab").click ->
    $(@).removeClass("disabled").addClass "enable"

    # Pagination button function
    first_tab = $(this).hasClass("first-tab")
    last_tab = $(this).hasClass("last-tab")

    if first_tab is true
      $(".prev").addClass "disabled"
    else
      $(".prev").removeClass "disabled"
    if last_tab is true
      $(".next").attr "disabled", "disabled"
    else
      $(".next").removeAttr "disabled", "disabled"

    # validations
    if $(".exam_question_form").is(":visible") is true
      validate()
    else
      check_value()
window.tabs = tabs
window.validate = validate

enableSuccess = ->
  count = true
  $(".validate").each (e) ->
    count = false if $.trim($(this).val()).length is 0
  if $.trim($("#exam_question_question_prompt").val()).length > 0
    $("ul.nav-stacked li:first").addClass "enable"
  else
    $("ul.nav-stacked li:first").removeClass "enable"
  if count is true
    $("ul.nav-stacked li:first").addClass "enable"
    $("ul.nav-stacked li.answertab").addClass "enable"
    $(".btn-success").removeClass("disabled").removeAttr "disabled"
  else
    $(".btn-success").addClass("disabled").addClass "disabled"
    $("ul.nav-stacked li.answertab").removeClass "enable"
window.enableSuccess= enableSuccess

check_value = ->
  $(".btn-success").addClass("disabled").addClass "disabled"
  $("ul.nav-stacked li:first").removeClass "enable"
  check_err = "<div class=\"popover fade right in error-popover\"><div class=\"arrow\"></div><h3 class=\"popover-title\"></h3><div class=\"popover-content\"></div></div>"
  title = $.trim($("#medical_case_title").val())
  age = $.trim($("#medical_case_age").val())
  gender = $.trim($("#medical_case_gender").val())
  race = $.trim($("#medical_case_race_id").val())
  chief = $.trim($("#medical_case_chief_complaint").val())
  history = $.trim($("#medical_case_history_of_present_illness").val())
  if title.length is 0
    if $(".medical_case_title .popover").hasClass("popover") is false
      $(".medical_case_title").append check_err
      $('.medical_case_title .popover-content').text('Title cannot be blank')
    return true
  if age.length is 0
    if $(".medical_case_age .popover").hasClass("popover") is false
      $(".medical_case_age").append check_err
      $('.text-area .medical_case_age .popover-content').text('Age cannot be blank')
    return true
  if age.length > 2 || age is '0' || age is '00'  || !(/^\d{1,2}$/).test(age)
    if $(".medical_case_age .popover").hasClass("popover") is false
      $(".medical_case_age").append check_err
      $('.text-area .medical_case_age .popover-content').text('Enter valid age')
    return true
  if gender.length is 0
    if $(".medical_case_gender .popover").hasClass("popover") is false
      $(".medical_case_gender").append check_err
      $('.text-area .medical_case_gender .popover-content').text('Select gender')
    return true
  if race.length is 0
    if $(".medical_case_race .popover").hasClass("popover") is false
      $(".medical_case_race").append check_err
      $('.text-area .medical_case_race .popover-content').text('Select race')
    return true
  if chief.length is 0
    if $(".medical_case_chief_complaint .popover").hasClass("popover") is false
      $(".medical_case_chief_complaint").append check_err
      $('.text-area .medical_case_chief_complaint .popover-content').text('Chief Complaint cannot be blank')
    return true
  if history.length is 0
    if $(".medical_case_history_of_present_illness .popover").hasClass("popover") is false
      $(".medical_case_history_of_present_illness").append check_err
      $('.text-area .medical_case_history_of_present_illness .popover-content').text('History of Present Illness cannot be blank')
    return true
  $("ul.nav-stacked li:first").addClass "enable"
  $(".btn-success").removeClass("disabled").removeAttr "disabled"
  enableSuccess()
window.check_value = check_value

pagination = ->
  last_tab = $("#next ul li:last").hasClass("active")
  if last_tab is true
    $(".next").attr "disabled", "disabled"
  else
    $(".next").removeAttr "disabled", "disabled"

  #check first tab
  first_tab = $("#next ul li:first").hasClass("active")
  if first_tab is true
    $(".prev").attr "disabled", "disabled"
  else
    $(".prev").removeAttr "disabled", "disabled"
window.pagination= pagination

#validate exam questions
qus_err = "<div class=\"popover fade right in error-popover\" style=\"top: 114px; left: 287.0625px; display: block;\"><div class=\"arrow\"></div><h3 class=\"popover-title\"></h3><div class=\"popover-content\"></div></div>"
pre_validate = ->
  $(".validate").each (e) ->
    enableSuccess()
    if $(".exam_question_form").is(":visible") is true
      len = $.trim($(this).val()).length
      if $.trim($(this).val()).length is 0
        # $("ul.nav-stacked li:first").removeClass "enable"
        if $(this).parent().hasClass("exam_question_question_prompt")
          if $(".exam_question_question_prompt .popover").hasClass("popover") is false
            $(".exam_question_question_prompt").append qus_err
            $('.exam_question_question_prompt .popover-content').text('Question prompt cannot be blank')
        if $(this).parent().hasClass("exam_question_correct_answer")
          if $(".exam_question_correct_answer .popover").hasClass("popover") is false  and len is 0
            $(".exam_question_correct_answer").append qus_err
            $('.exam_question_correct_answer .popover-content').text(' Correct answer cannot be blank')
        if $(this).parent().hasClass("exam_question_incorrect_1")
          if $(".exam_question_incorrect_1 .popover").hasClass("popover") is false  and len is 0
            $(".exam_question_incorrect_1").append qus_err
            $('.exam_question_incorrect_1 .popover-content').text(' Incorrect answer cannot be blank')
        if $(this).parent('div').parent('td').hasClass('row2')
          if $("#row2 .exam_question_incorrect_answers_answer .popover").hasClass("popover") is false  and len is 0
            $("#row2 .exam_question_incorrect_answers_answer").append qus_err
            $('#row2 .popover-content').text(' Incorrect answer2 cannot be blank')
        if $(this).parent('div').parent('td').hasClass('row3')
          if $("#row3 .exam_question_incorrect_answers_answer .popover").hasClass("popover") is false  and len is 0
            $("#row3 .exam_question_incorrect_answers_answer").append qus_err
            $('#row3 .popover-content').text(' Incorrect answer3 cannot be blank')
        if $(this).parent('div').parent('td').hasClass('row4')
          if $("#row4 .exam_question_incorrect_answers_answer .popover").hasClass("popover") is false  and len is 0
            $("#row4 .exam_question_incorrect_answers_answer").append qus_err
            $('#row4 .popover-content').text(' Incorrect answer4 cannot be blank')


validate = ->
  enableSuccess()
  $(".validate").on "focusout input propertychange", ->
    enableSuccess()
    if $(".exam_question_form").is(":visible") is true
      len = $.trim($(this).val()).length
      if $.trim($(this).val()).length is 0
        # $("ul.nav-stacked li:first").removeClass "enable"
        if $(this).parent().hasClass("exam_question_question_prompt")
          if $(".exam_question_question_prompt .popover").hasClass("popover") is false
            $(".exam_question_question_prompt").append qus_err
            $('.exam_question_question_prompt .popover-content').text('Question prompt cannot be blank')
        if $(this).parent().hasClass("exam_question_correct_answer")
          if $(".exam_question_correct_answer .popover").hasClass("popover") is false  and len is 0
            $(".exam_question_correct_answer").append qus_err
            $('.exam_question_correct_answer .popover-content').text(' Correct answer cannot be blank')
        if $(this).parent().hasClass("exam_question_incorrect_1")
          if $(".exam_question_incorrect_1 .popover").hasClass("popover") is false  and len is 0
            $(".exam_question_incorrect_1").append qus_err
            $('.exam_question_incorrect_1 .popover-content').text(' Incorrect answer cannot be blank')
        if $(this).parent('div').parent('td').hasClass('row2')
          if $("#row2 .exam_question_incorrect_answers_answer .popover").hasClass("popover") is false  and len is 0
            $("#row2 .exam_question_incorrect_answers_answer").append qus_err
            $('#row2 .popover-content').text(' Incorrect answer2 cannot be blank')
        if $(this).parent('div').parent('td').hasClass('row3')
          if $("#row3 .exam_question_incorrect_answers_answer .popover").hasClass("popover") is false  and len is 0
            $("#row3 .exam_question_incorrect_answers_answer").append qus_err
            $('#row3 .popover-content').text(' Incorrect answer3 cannot be blank')
        if $(this).parent('div').parent('td').hasClass('row4')
          if $("#row4 .exam_question_incorrect_answers_answer .popover").hasClass("popover") is false  and len is 0
            $("#row4 .exam_question_incorrect_answers_answer").append qus_err
            $('#row4 .popover-content').text(' Incorrect answer4 cannot be blank')
    else
      check_value()
    popoverremove()


#image uploading
  $('.delete_img').click ->
    $("#exam_question_photo").val('')
    $('#photo_name').html ''
    $('.photolist').hide()

  $("#exam_question_photo").change ->
    $('.photolist').show()
    ext = $(this).val().split(".").pop().toLowerCase()
    val = $(this).val().split("\\").pop()
    $('#photo_name').html("<span>"+val+"</span>")
    if $.inArray(ext, ["gif", "png", "jpg", "jpeg"]) is -1
      $(".btn-success").addClass("disabled").addClass "disabled"
      $('#photo_name').html("<span style = 'color:red'>Invalid file format</span>")


  $(".medical_case_gender select, .medical_case_race select").change ->
    check_value()
window.validate = validate

openWiz = ->
  tabs()
  validate()
  JQFUNCS = runFunc:
    next:
      run: (id) ->        
        $curr = $("#" + id + " li:first")
        $("#" + id + " .prev-next a").on "click", (e) ->

          #$curr.removeClass("active");
          if $(this).hasClass("next") is true
            if $(".exam_question_form").is(":visible") is true
              validate()
            else
              check_value()
            $curr = $curr.next()  if $curr.next().html()
          else
            if $(".exam_question_form").is(":visible") is true
              pre_validate()
              validate()
            else
              check_value()
            if $curr.prev().html()
              $curr = $curr.prev()
              $(".next").removeAttr "disabled"

          #$('.btn-success').addClass('disabled').attr('disabled','disabled');
          $(".prev").removeClass "disabled"
          $("#next ul li.active").removeClass "active"
          $curr.addClass "active enable"
          if $curr.hasClass("answertab") is true
            $curr.removeClass "enable"
            $curr.addClass "active "
          $curr.removeClass "disabled"
          $(".demoarea .tab-pane.active").removeClass "active"
          ref = $("#next ul li.active a")[0].getAttribute("href")
          $("" + ref + "").addClass "active"

          #checking last tab and enable the submit button
          pagination()

  JQ4UFUNCS =
    init: ->
      _this = this
      fns = ["next"]      
      $.each fns, (i, fn) ->        
        # check for presence of function
        parentPresence = (if not $("#maindemoarea").html()? then false else true)
        fnPresence = (if parentPresence is true then ($("#maindemoarea").html().indexOf("id=\"" + fn + "\"") isnt -1) else ($("body").html().indexOf("id=\"" + fn + "\"") isnt -1))
        JQFUNCS.runFunc[fn]["run"] fn  if fnPresence
    # helper function to strip the main id for the demo
    getId: (elem) ->
      thisId = elem.attr("id")
      thisId = thisId.substring(0, thisId.lastIndexOf("-"))
      "#" + thisId
  jQuery(document).ready ->
    JQ4UFUNCS.init() # setup event handlers and code display
window.openWiz = openWiz
