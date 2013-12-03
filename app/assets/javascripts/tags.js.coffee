editTags = ->
  hiddenTag = $(".case_tag").val()
  unless hiddenTag is ""
    editTagsList = hiddenTag.split(",")
    $(".case_others_list").html()
    tagCount = 0
    while tagCount < editTagsList.length
      $(".case_others_list").append "<span id='" + tagCount + "' class='tag'>" + editTagsList[tagCount] + "&nbsp;<span id='close-tag' class='" + tagCount + "' style='cursor:pointer;'><i class='icon-remove icon-white' style='background-image:none;'></i></span></span>"
      tagCount++
    $(".case_tag").val ""
window.editTags = editTags


tagCount = 0
$(document).on "keypress", ".case_tag", (event) ->
  hiddenTag = $(".new-tag").val()
  entered_tag = $(this).val().replace(/[,]$/, "")
  tagArray = hiddenTag.split(",")
  $(".error_tag").hide()
  bug = 0
  if event.which is 13
    tagArray.forEach (item) ->
      if entered_tag is item
        bug=1
        $(".error_tag").show().html "Tag is already exist."
        $(".case_tag").val ""
        false
  if jQuery.unique(tagArray).length < 20
    if bug is 0
      if event.keyCode is 13 or event.keyCode is 188
        if $(this).val().replace(/[,]$/, "").trim() is ""
          $(".error_tag").show().html "Please enter tag"
          $(".case_tag").val ""
          return false
        else unless $(this).val().match(/^[A-z][A-z ]*[0-9]*$/)
          $(".error_tag").show().html "Please enter valid tag"
          $(".case_tag").val ""
          return false

        $(".case_others_list").html()
        $(".case_others_list").append "<span id='" + tagCount + "' class='tag'>" + entered_tag + "<span id='close-tag' class='" + tagCount + "' style='cursor:pointer;'><i class='icon-remove icon-white' style='background-image:none;'></i></span></span>"
        beforeTagValue = $(".new-tag").val()
        if beforeTagValue is ""
          afterTagValue = entered_tag
        else
          afterTagValue = beforeTagValue + "," + entered_tag
        $(".new-tag").val afterTagValue
        $(".case_tag").val ""
        tagCount++
        $(".error_tag").hide()
  else
    $(".error_tag").show().html "Tags can't be more than 20"

$(document).on "click", "#close-tag", ->
  classClose = $(this).attr("class")
  $("#" + classClose).remove()
  tag = []
  $.each $(".tag"), (i, v) ->
    tag.push $(v).text()

  $(".new-tag").val tag
  true
