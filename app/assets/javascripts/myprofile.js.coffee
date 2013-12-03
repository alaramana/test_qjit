# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#calling changepassword function


$("#user_password").blur ->
  $("#password-reset").children().find("#errorpassowrd").text ""

$('#user_password_confirmation').keyup ->
  $("#password-reset").children().find("#errorpassowrd").text ""

$("form#edit_user").submit ->
  if $("#password-reset").is(":visible")
    pss = $("#user_password").val()
    if pss.length is 0
      $("form[data-validate]").validate()
      $("#password-reset").children().find("#errorpassowrd").text "Password can't be blank"
      false
    else if $("#user_password_confirmation").val().length is 0
      $("form[data-validate]").validate()
      $("#password-reset").children().find("#errorpassowrd").text "Password does not match your confirmation"
      false
  else
    return

changePassword = ->
  pass = $("#user_password").val()
  passrest = $("#user_password_confirmation").val()
  if pass.length is 0
    #$("#password-reset").children().find("#errorpass").text "Password can't be blank"
  else $("#errorpass").hide()  if pass is passrest  if not (pass.length < 8) or not (passrest.length < 8)
password_error = $("#password-reset").children().find("#errorpass")
if password_error.is(":visible")
  unless password_error.val().length is 0
    $("#reset").hide()
    $("#reset-cancel").show()
    $("#password-reset").show()
    $("#user_password").removeClass("disabled").removeAttr "disabled"
    $("#user_password_confirmation").removeClass("disabled").removeAttr "disabled"
  else
    $(".none").show()
$("#user_password_confirmation, #user_password").bind "blur", (event) ->
  $("#errorpass").show()
  changePassword()

$("#reset .btn").click ->
  $("#errorpass, #reset").hide()
  $("#reset-cancel, #password-reset").show()
  $("#user_password").removeClass("disabled").removeAttr "disabled"
  $("#user_password_confirmation").removeClass("disabled").removeAttr "disabled"
  $("form[data-validate]").validate()

$("#reset-cancel .btn").click ->
  $("#reset-cancel,#password-reset").hide()
  $("#reset").show()
  $("#user_password, #user_password_confirmation").val ""
  $("#user_password").addClass("disabled").attr "disabled", "disabled"
  $("#user_password_confirmation").addClass("disabled").attr "disabled", "disabled"
  $("form[data-validate]").validate()

$("#edit_user").submit ->
  if $('.field_with_errors').is(":visible")
    $("#password-reset").children().find("#errorpassowrd").text ""
  if $("#password-reset").children().find("#errorpass").is(":visible")
    $("form[data-validate]").validate()
    false
  else
    true
