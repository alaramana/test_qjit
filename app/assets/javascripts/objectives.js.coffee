# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('#objective_name').keypress ->
  if $('#objective_name').val() != 0
    $('#objective_name').disableClientSideValidations()
    $('.field_with_errors .message').remove()
  else if $('#objective_name').val() == 0
    $('#objective_name').enableClientSideValidations()

$(".table #objectives").on "click", ".status", ->
  record_id = $(this).attr("id")

  name = $(this).attr("title")
  mname = $(this).attr("name")
  $("#modal-from-dom").on("show", ->
    id = $(this).data("id")
    removeBtn = $(this).find(".danger")
    $(".modal-header h3").html "<h3> " + name + " '"+mname+"'  Assignment </h3>"
  ).modal backdrop: true
  $(".confirm-delete").on "click", (e) ->
    e.preventDefault()
    id = $(this).data("id")
    $("#modal-from-dom").data("id", id).modal "show"

  $(".confirm").click ->
    window.location.href = "/admin/objectives/" + record_id + "/toggle_status"  if $(this).attr("id") is "yes_id"


$('#new_objective').keypress ->
  if $('#objective_start_date').val() != 0 or $('#objective_name').val() != 0
    $('#objective_start_date').disableClientSideValidations()
    $('#objective_name').disableClientSideValidations()
    $('.field_with_errors .message').remove()
  else if $('#objective_start_date').val() == 0 or  $('#objective_name').val() == 0
    $('#objective_start_date').enableClientSideValidations()
    $('#objective_name').enableClientSideValidations()


$('.obj_btn').click ->
  if $('#objective_start_date').val() == '' or $('#objective_name').val() == ''
    $('#objective_start_date').enableClientSideValidations()
    $('#objective_name').enableClientSideValidations()
    
  else
    $('#objective_start_date').disableClientSideValidations()
    $('#objective_name').disableClientSideValidations()