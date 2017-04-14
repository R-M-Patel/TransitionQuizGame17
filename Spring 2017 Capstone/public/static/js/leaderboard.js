$(document).ready(function() {
  //This function will run and populate the leaderboard with users with scores above 0 when the page loads
  var object = {
    "category": $("#category").val(),
    "timePeriod": $("#timePeriod").val(),
    "subCategory": $("#subCategory").val(),
    "action": "scores"
  };
  $.ajax({
    type: 'POST',
    url: '../includes/get_leaderboard.php',
    data: object,
    dataType: "text",
    success: function(data) {
      //When the scores are returned, the following code appends the scores, descending, into the table
      set_leaderboard(data);
    },
    error: function(){
      console.log("Error");
    }
  });
  var object2 = {
    "action": "categories"
  };
  $.ajax({
    type: 'POST',
    url: '../includes/get_leaderboard.php',
    data: object2,
    dataType: "text",
    success: function(data) {
      var array = JSON.parse(data);
      for(var x = 0; x < array.length; x++){
        $('#category').append("<option value='"+array[x]+"'>" + array[x] + "</option>");
      }
    },
    error: function(){
      console.log("Error");
    }
  });
  
  //This function will fire when the user selects a specific category from the drop down selector
  //It will populate the leaderboard based on the selected category.
  $('#category').change(function(){
    var object = {
      "category": $("#category").val(),
      "timePeriod": $("#timePeriod").val(),
      "subCategory": "ALL",
      "action": "scores"
    };
    $.ajax({
      type: 'POST',
      url: '../includes/get_leaderboard.php',
      data: object,
      dataType: "text",
      success: function(data) {
        $("#leaderboard tbody").empty();
        set_leaderboard(data);
      },
      error: function(){
        console.log("Error");
      }
    });

    var object2 = {
      "category": $("#category").val(),
      "action": "subcategories"
    };
    $.ajax({
      type: 'POST',
      url: '../includes/get_leaderboard.php',
      data: object2,
      dataType: "text",
      success: function(data) {
        var array = JSON.parse(data);
        $("#subCategory").empty();
        $("#subCategory").append("<option value='ALL'>All</option>");

        if (array != null) {  // if array is null, there are no subcategories, don't need to append options
          for(var x = 0; x < array.length; x++){
            $("#subCategory").append("<option value='" + array[x] + "'>" + array[x] + "</option>");
          }
        }
      },
      error: function(){
        console.log("Error");
      }
    });    
  });

  //This function will fire when the user selects a specific subcategory from the drop down selector
  //It will populate the leaderboard based on the selected subcategory.
  $('#subCategory').change(function(){
    var object = {
      "category": $("#category").val(),
      "timePeriod": $("#timePeriod").val(),
      "subCategory": $("#subCategory").val(),
      "action": "scores"
    };
    $.ajax({
      type: 'POST',
      url: '../includes/get_leaderboard.php',
      data: object,
      dataType: "text",
      success: function(data) {
        $("#leaderboard tbody").empty();
        set_leaderboard(data);
      },
      error: function(){
        console.log("Error");
      }
    });
  });

  //This function will fire when the user selects a specific time period from the drop down selector
  //It will populate the leaderboard based on the selected time period.
  $('#timePeriod').change(function(){
    var object = {
      "category": $("#category").val(),
      "timePeriod": $("#timePeriod").val(),
      "subCategory": $("#subCategory").val(),
      "action": "scores"
    };
    $.ajax({
      type: 'POST',
      url: '../includes/get_leaderboard.php',
      data: object,
      dataType: "text",
      success: function(data) {
        $("#leaderboard tbody").empty();
        set_leaderboard(data);
      },
      error: function(){
        console.log("Error");
      }
    });
  });  
});

//This function parses the data returned from the AJAX call and appends it into the leaderboard.
function set_leaderboard(data){
  var scores = JSON.parse(data);
  var scores_ascending = scores[0];
  var users = scores[1];
  var count = scores_ascending.length;
  rank = 1;
  for(count; count > 0; count--) {
    var current_score = scores_ascending[count - 1];
    for (var x = 0; x < users[current_score].length; x++){
      var row = scores_ascending[count - 1];
      var usr = users[row];
      $('#leaderboard tbody').append("<tr><td class='pad'>" + rank + "</td><td class='pad'>" + usr[x] + "</td><td class='pad'>" + current_score + "</td></tr>");
      rank++;
    }
  }
}