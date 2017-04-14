// display submit category modal
function displayCategoryModal() {
  $('#submitcat').modal('show');
}

// validate category
function isCategoryValid() {
  var categoryId = $("#newcatdropdown").val();
  if (categoryId != "cat") {
    return true;
  }

  var newCategoryName = $("#category").val();
  if (newCategoryName.length < 3) {
    return false;
  }

  $.ajax({
    url: "../includes/ajax_calls.php",
    type: "get",
    data: {
      get_action: "check_category_availability",
      category_text: newCategoryName
    },
    success: function(data) {
      var results = JSON.parse(data);
      if (results.exists == "false") {
        return true;
      } else {
        return false;
      }
    },
    error: function(xhr) {
      alert(xhr);
    }
  });
}

// validate quiz
function isQuizValid() {
  var newQuizName = $("#subcategory").val();
  if (newQuizName.length < 3) {
    alert("quiz returning false");
    return false;
  }
}

// submit category
function submitCategory() {      
  // perform validation like the create user account
  // don't let them submit if category already exists
  // quiz name can be duplicated 
  var categoryId = $("#newcatdropdown").val();

  if (categoryId != "cat") {
    var postData = {
      "action": "create_quiz",
      "quiz_name": $("#subcategory").val(),
      "category_id": categoryId
    };

    $.ajax({
      type: "POST",
      url: "../includes/ajax_calls.php",
      data: postData,
      dataType: "text",
      success: function(text) {
        alert("Quiz Created");
        initCategoryDropdown();
        clearTextFields();
        $('#submitcat').modal('hide');
      },
    });
  } else {
    var postData = {
      "action": "create_category",
      "category_name": $("#category").val(),
      "quiz_name": $("#subcategory").val()
    };

    $.ajax({
      type: "POST",
      url: "../includes/ajax_calls.php",
      data: postData,
      dataType: "text",
      success: function(text) {
        alert("Category Created");
        initCategoryDropdown();
        clearTextFields();
        $('#submitcat').modal('hide');          
      },
    });
  }
}

// clear text fields
function clearTextFields() {
  $("#answer1").val('');
  $("#answer2").val('');
  $("#answer3").val('');
  $("#answer4").val('');
  $("#questionText").val('');
  $("#explanation").val('');
  $("#category").val('');
  $("#subcategory").val('');
}

// submit a question to the database
function submitQuestion(correctQuestion) {
  var questionText = $("#questionText").val();
  var questionExplanation = $("#explanation").val();
  var quizId = $("#subdropdown").val();

  var answerText1 = $("#answer1").val();
  var answerText2 = $("#answer2").val();
  var answerText3 = $("#answer3").val();
  var answerText4 = $("#answer4").val();
  var correctAnswerText = correctQuestion.value;

  var postData = {
    "action": "create_question",
    "question_text": questionText,
    "explanation": questionExplanation,
    "quiz_id": quizId,
    "answer1": answerText1,
    "answer2": answerText2,
    "answer3": answerText3,
    "answer4": answerText4,
    "correct_answer": correctAnswerText
  };

  $.ajax({
    type: "POST",
    url: "../includes/ajax_calls.php",
    data: postData,
    dataType: "text",
    success: function(text) {
      //alert("Question Added");
      $('#confirm').modal('show');
      clearTextFields();
    },
  });
}

// hide or show the category text box as needed
function updateCategoryModal() {
    if ($("#newcatdropdown").val() != "cat") {
      $("#category").hide();
    } else {
      $("#category").show();
    }
}

// update the quiz dropdown
function updateQuizDropdown() {
  $("#subdropdown").empty();
  $("#subdropdown").load("../includes/dropdown_handler.php?category=" + $("#catdropdown").val());
}

// initialize dropdowns
function initCategoryDropdown() {
  $('#catdropdown').empty();
  $.ajax({
    url: "../includes/ajax_calls.php",
    type: "get",
    data: {
      get_action: "get_categories"
    },
    success: function(data) {
      var categories = JSON.parse(data);
      $.each(categories, function (i, item) {
        if (item.active_flag == "Y") {
          $('#catdropdown').append($('<option>', { 
            value: item.category_id,
            text : item.category_name 
          }));
          $('#newcatdropdown').append($('<option>', { 
            value: item.category_id,
            text : item.category_name 
          }));
        }            
      });
      updateQuizDropdown();
    },
    error: function(xhr) {
      alert(xhr);
    }
  });
}

// register click handlers
$(document).ready(function() {
  $("#select1").on("click", function() {
    submitQuestion(document.getElementById("answer1"));
  });
  $("#select2").on("click", function() {
    submitQuestion(document.getElementById("answer2"));
  });
  $("#select3").on("click", function() {
    submitQuestion(document.getElementById("answer3"));
  });
  $("#select4").on("click", function() {
    submitQuestion(document.getElementById("answer4"));
  });

  $(document).ready(initCategoryDropdown);
  $(document).ready(updateQuizDropdown);
  $("#catdropdown").change(updateQuizDropdown);
  $("#newcatdropdown").change(updateCategoryModal);
});