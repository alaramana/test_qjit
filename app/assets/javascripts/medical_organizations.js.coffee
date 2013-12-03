# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(".table #medical_organizations").on "click", ".status", ->
  record_id = $(this).attr("id")
  name = $(this).attr("title")
  mname = $(this).attr("name")
  
  $("#modal-from-dom").on("show", ->
    id = $(this).data("id")
    removeBtn = $(this).find(".danger")
    $(".modal-header h3").html "<h3> " + name + " '"+mname+"' medical organization </h3>"
  ).modal backdrop: true

  $(".confirm-delete").on "click", (e) ->
    e.preventDefault()
    id = $(this).data("id")
    $("#modal-from-dom").data("id", id).modal "show"

  $(".confirm").click ->
    window.location.href = "/admin/medical_organizations/" + record_id + "/toggle_status"  if $(this).attr("id") is "yes_id"
