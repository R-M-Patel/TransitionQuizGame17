// bug_report.js
//
// This file provide functions to support the bug_report modal.
// This is included in the footer (so that it is included on all pages) to allow
// the users to report a bug from any page on the site.

function sendBugReport(){
  var message = document.getElementById('message').value;

  if (message.length >= 3) {
    $('#sendbugreport').modal('hide');
    
    //clear report question text box
    document.getElementById('message').value= "";

    var postData = {
      "action": "submit_bug",
      "report_text": message
    };

    $.ajax({
      type: "POST",
      url: "../includes/ajax_calls.php",
      data: postData,
      dataType: "text",
      success: function(data) { }, // don't need to do anything else on success
      error: function(jqXHR, textStatus, error) { }
    });
  } else {
    $("#bugreporterror").css("display", "block");
  }
}

$(document).ready(function() {
  // register the click event handlers
  $("#message").on("keypress", function() {
    if ($("#message").val().length >= 2) {
      $("#bugreporterror").css("display", "none");
    }
  });
});