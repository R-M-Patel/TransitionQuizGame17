// This JavaScript handles updates to the dropdowns on 
// select_quiz.php

$(document).ready(function() {
  function updateDropdowns() {
    $("#quiz").empty();
    $("#quiz").load("../includes/dropdown_handler.php?category=" + $("#category").val());
  }

  $(document).ready(updateDropdowns);
  $("#category").change(updateDropdowns);
});