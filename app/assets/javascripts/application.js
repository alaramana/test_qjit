// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.autocomplete
//= require jquery.ui.datepicker
//= require twitter/bootstrap
//= require rails.validations
//= require_tree .

$(function () {

  // functions for catching 
  $("#qpaginated").on('click','th a, .pagination li a, .page-selector li a',function(){
    $.getScript(this.href);
    return false;
  });
  $(".qsearchable").submit(function(){
    $.get(this.action, $(this).serialize(), null, "script");
    return false;
  });

  // Organization
  $("#search_filter_org_id").on('change',function(){
  	var org = $(this).val();
  	$.ajax({
  			type: "GET",
        url: "/admin/reports/org_assignments?org=" + org,
        success: function(data) {
        var tag = [];
  			$.each(data, function( i, l ){
					tag.push("<option value="+l[1] +">"+l[0]+"</option>")
				});
  			$('#search_filter_exam_questions_objective_id_in').html('<option></option>' + tag);
        },
        error: function(jxhr, msg, err) { alert("faild")}
      });
	});

  /* FIXME Make this a javascript extension and extensible to other parts of the application */
  $(".disclosable").each(function(){
  	var disclosed = false;
  	var totalCount = $(this).data("total-count");
  	var discloseCount = $(this).data("disclose-count");

 		$(".discloser",this).click(function(){
  		disclosed = !disclosed
 			if(disclosed)
 			{
 				$(".disclosee",$(this).closest(".disclosable")).show();
 				$(this).html("Show Fewer");
 				$(".disclose-count",$(this).closest(".disclosable")).html(discloseCount);
 			}
  		else
 			{
 				$(".disclosee",$(this).closest(".disclosable")).hide();
 				$(this).html("Show More");
 				$(".disclose-count",$(this).closest(".disclosable")).html(totalCount);
 			}
 		});
  });

  $("#resent_email").on("click",function () {  	
  	$(".old_email input").attr("name", "");
  	$(".new_email input").attr("name", "user[email]");
  	$("#edit_user").submit()
  	return false
  });
});
