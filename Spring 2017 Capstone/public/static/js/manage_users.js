// toggle the status of the user
function toggleStatus(flag, username) {
  var id = flag + "_" + username;
  var button = document.getElementById(id);

  var postData = {
    "action": "toggle_user_flag",
    "flag_name": flag,
    "new_flag_value": (button.innerHTML == "No - Promote") ? "Y" : "N",
    "username": username
  };

  $.ajax({
    type: "POST",
    url: "../includes/ajax_calls.php",
    data: postData,
    dataType: "text",
    success: function(data) { 
      button.innerHTML = (button.innerHTML == "No - Promote") ? "Yes - Demote" : "No - Promote";
    },
    error: function(jqXHR, textStatus, error) { alert("Error"); }
  });
}

// make an ajax call to reset the user's score and update table
function resetScore(username) {
  var id = "score_" + username;
  var element = document.getElementById(id);

  var postData = {
    "action": "reset_user_score",
    "username": username
  };

  $.ajax({
    type: "POST",
    url: "../includes/ajax_calls.php",
    data: postData,
    dataType: "text",
    success: function(data) { element.innerHTML = "0"; },
    error: function(jqXHR, textStatus, error) { }
  });
}