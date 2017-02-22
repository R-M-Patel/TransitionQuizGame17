<?php session_start(); ?>
<?php require_once("../includes/db_connection.php") ?>
<?php require_once("../includes/functions.php"); ?>

<?php confirm_login_status(); ?>

<?php include("../includes/header.php"); ?>

<script src="../public/static/js/jquery.easing.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script> 
<script src="../public/static/js/w2ui-1.4.3.min.js"></script>
<script>
  var the_quiz;   // will store our quiz data

  // This function found on stackoverflow - gets the GET variables out of the URL
  // http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
  function getParameterByName(name, url) {
    if (!url) {
      url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
  }

  function displayGetReadyDialog() {
    $("#getready").modal({ backdrop: 'static', keyboard: false });
    if (the_quiz.questions.length > 0) {
      alert(the_quiz.questions[0].question_text);

      $("#ready_title").html("Are you ready?");
      $("#questions_found").html((the_quiz.questions.length == 1) ? 
          "Found " + 1 + " question!" : 
          "Found " + the_quiz.questions.length + "questions!");
      $("#time_limit").html(the_quiz.questions.time_per_question == 0 ? 
          "You have unlimited time per question to choose the correct answer." : 
          "You have " + the_quiz.questions.time_per_question + " seconds per question to choose the correct answer.");
      $(".no-questions").css("display","none");
    }
    else {
      $("#ready_title").html = "No Questions Found";
      $("#gobutton").css("display","none");
    }
  }  
  
  //alert("Quiz:" + quiz_id + "\nNumber: " + num_questions + "\nTimed: " + timed + "\nMine: " + mine);
  $(document).ready(function() {
    var quiz_id = getParameterByName("quiz");
    var num_questions = getParameterByName("number");
    var timed = getParameterByName("timed");
    var mine = getParameterByName("mine");

    $.ajax({
      type: "POST",
      url: "get_quiz.php",
      data: {
        "quiz": quiz_id,
        "timed": timed,
        "number": num_questions,
        "mine": mine
      },
      dataType: "text",
      success: function(data) {
        console.log(data);
        the_quiz = JSON.parse(data);
        
        displayGetReadyDialog();
      },
      error: function(jqXHR, textStatus, error) { }
    });
  });

  

</script>
</head>
<body id="main">
  <?php echo get_navbar(); ?>

  <div style="z-index:2147483646;" class="modal fade" id="getready" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header" style="text-align:center">
            <h1 style="display:inline" id="ready_title"></h1>
        </div>
        <div class="modal-body" style="text-align:center">
          <span id="questions_found"></span>
          <br /><br />
          <button class="btn btn-success" style="border-radius: 25px;" onclick="runQuestion()" id="gobutton">
            <h2 class="link-button">Start</h2>
          </button>
          <br /><br />
          <span id="time_limit"></span>
          <br /><br />
          <a href="/submitNew" class="btn btn-info no-questions" style="border-radius: 25px;">
            <h2 class="link-button">Submit New Questions</h2>
          </a>
          <br /><br />
          <a href="/ReviewNewQuestions" class="btn btn-warning no-questions" style="border-radius: 25px;">
            <h2 class="link-button">Review New Questions</h2>
          </a>
          <br /><br />
          <span class="no-questions"> Questions must have a user rating of 5 or administrative permission to be active.</span>
          <br />
          <a href="index.php">
            <h5 style="display:inline"><br>Return Home</h5>
          </a>
          <br />
        </div>
      </div>
    </div>
  </div>

<?php include("../includes/footer.php"); ?>