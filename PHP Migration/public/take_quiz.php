<?php session_start(); ?>
<?php require_once("../includes/db_connection.php") ?>
<?php require_once("../includes/functions.php"); ?>

<?php confirm_login_status(); ?>

<?php include("../includes/header.php"); ?>

<script src="static/js/jquery.easing.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script> 
<script src="static/js/w2ui-1.4.3.min.js"></script>

</head>
<body id="main">
  <?php echo get_navbar(); ?>

  <br /><br /><br /><br />
  <div class="container" id="content">
    <div class="container" style= "text-align:center; position:relative;">
        <h4 id="question" style="text-align:center"></h4>
    </div>

    <!-- Bowen - This DIV is always shown, but the below DIVs are set to modal (can't click out of), so this section is effectively hidden when another section is shown -->
    <!--Quiz-->
    <font size=5>
      <div class="container">
        <div class="large-lg-12 text-center">
          <img style="display:none;" id="img" src="" style="text-align:center;" class="smaller-image img-rounded"></img>
        </div><br/>

        <div class="col-lg-3"></div>
        <div class="col-lg-3" style="text-align:center; position:relative;">
          <button id="answer1" type="submit" name="userAnswer" value=1 class="btn btn-danger submit-a-button" style="border-radius: 15px;"></button><br/><br/>
        </div>
        <div class="col-lg-3" style="text-align:center; position:relative;">
          <button id="answer2" type="submit" name="userAnswer" value=2 class="btn btn-info submit-a-button" style="border-radius: 15px;"></button><br/><br/>
        </div>
        <div class="col-lg-3"></div>
      </div>
      <div class="container">
        <div class="col-lg-3"></div>
        <div class="col-lg-3" style="text-align:center; position:relative;">
          <button id="answer3" type="submit" name="userAnswer" value=3 class="btn btn-success submit-a-button" style="border-radius: 15px;"></button><br/><br/>
        </div>
        <div class="col-lg-3" style= "text-align:center; position:relative;">
          <button id="answer4" type="submit" name="userAnswer" value=4 class="btn btn-warning submit-a-button" style="border-radius: 15px;"></button>
        </div>
        <div class="col-lg-3"></div>
      </div>
      <button type="hidden submit" id="submit" name="userAnswer" style="visibility: hidden" value=0></button>
    </font>

    <!-- &#x221E == The Infinity Symbol -->
    <div class="container" id="timer" style="text-align:center"><p>&#x221E;</p></div>
    <div class="container" style="text-align:center"><h4 style="display:inline;" id="counter"></h4></div>
  </div>

  <!--Get Ready Modal-->
  <!-- display this when the quiz is ready to begin -->
  <div style="z-index:2147483646;" class="modal fade" id="getready" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header" style="text-align:center">
            <h1 style="display:inline">Are You Ready?</h1>
        </div>
        <div class="modal-body" style="text-align:center">
          <span id="num_questions">Questions Found!</span><br/>
          <br /><button class="btn btn-success" style="border-radius: 25px;" onclick= "runQuestion()" id="gobutton"><h2 class="link-button">Start</h2></button><br />
          <br/><span id="time_per_question"></span><br />
          <a href="index.php"><h5 style="display:inline"><br />Return Home</h5></a>
          <br />
        </div>
      </div>
    </div>
  </div>

  <!--No Questions Modal-->
  <!-- display this when there were no questions in the quiz -->
  <div style="z-index:2147483646;" class="modal fade" id="no_questions" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header" style="text-align:center">
          <h1 style="display:inline">No Questions Found!</h1>
        </div>
        <div class="modal-body" style="text-align:center">
          <br /><a href="submit_new.php" class="btn btn-info" style="border-radius: 25px;"><h2 class="link-button">Submit New Questions</h2></a><br />
          <br /><a href="review_new_questions.php" class="btn btn-warning" style="border-radius: 25px;"><h2 class="link-button">Review New Questions</h2></a><br />
          <br/><span> Questions must have a user rating of 5 or administrative permission to be active. </span><br />
          <a href="index.php"><h5 style="display:inline"><br>Return Home</h5></a>
          <br />
        </div>
      </div>
    </div>
  </div>

  <!-- Bowen - this DIV is shown when when the question is answered - see submitQ.js. 
       Then hidden once the Next Question button is clicked - see runNextQuestion function -->
  <!--Results Modal-->
  <div class="modal fade" data-keyboard="false" data-backdrop="static" id ="results" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header" id="title" style="text-align:center;">
            <span style="color:red" id="popupHead"></span>
        </div>
        <div class="modal-body">
          <div style=" font-size: 24px; line-height: 110%; text-align:left;">
            <h3 style="display:inline">Results: </h3>
            <ol id="list">
              <li style="color: #f44336;" id='popupAns1'></li>
              <li style="color: #f44336;" id='popupAns2'></li>
              <li style="color: #f44336;" id='popupAns3'></li>
              <li style="color: #f44336;" id='popupAns4'></li>
            </ol>
            <h3 style="display:inline">Explanation: </h3>
            <p id='explanation'></p>
          </div>
        </div>
        <div class="modal-footer">
          <button onclick="vote(1)" class="btn btn-success pull-left"><i class = "fa fa-arrow-up"></i></button>
          <button onclick="vote(0)" class="btn btn-danger pull-left"><i class = "fa fa-arrow-down"></i></button>

          <p style="display:inline" class="pull-left" id="numVotes"></p>
          <a class="btn btn-info" id="report" href="#sendreport" data-toggle="modal"><i class="fa fa-flag" aria-hidden="true"></i></a>
          <button class="btn btn-primary text-right" id="nextquestionbutton">Next Question</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Bowen - this div is shown when the user clicks the flag button (see id="report" in Results modal). 
       Then hidden in sendReport() function -->
  <!--Report Modal-->
  <div style="z-index:2147483646;" class="modal fade" id="sendreport" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5>Report Question</h5>
        </div>
        <div class="modal-body">
            Describe the problem:<br><br>
          <textarea class="form-control" rows="3" cols="40" id="comment" name="comment" maxlength="350" required ></textarea>
          <br />
        </div>
        <div class="modal-footer">
          <a class="btn btn-default text-right" data-dismiss="modal">Close</a>
          <button class="btn btn-primary" onclick="sendReport()">Submit</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Bowen - this div is displayed at the end of the quiz (shown when counter = number of questions -->
  <div class="container" id="quizResults" style="text-align:center; display:none">
    <div class="container">
      <h2 id="correctBox" style="text-align:center"></h2>
      <h4 id="pointsBox" style="text-align:center"></h4>
      <div class="col-sm-6">
        <a href="javascript:window.location.href=window.location.href" class="btn btn-success" style="border-radius: 25px;">
          <h3 class="link-button">Play Again</h3>
        </a><br /><br />
      </div>
      <div class="col-sm-6">
        <a href="/TransitionQuizGame17\PHP Migration\public\select_quiz.php" class="btn btn-info" style="border-radius: 25px;">
          <h3 class="link-button">New Quiz</h3>
        </a><br/><br/>
      </div>
      <span class="alignleft">Question</span>
      <span class="aligncenterleft">Your Answer</span>
      <span class="aligncenterright">Correct Answer</span>
      <span class="alignright">Points&nbsp;</span>
      <br /><br />
    </div>
  </div>

<script>
  var theQuiz;          // will store our quiz data
  var questionNum = 0;  // the current question number
  var timeLeft = 0;     // the time remaining for this question
  var timerId;          // the timer so we can start/stop it
  var score = 0;        // score earned for the quiz
  var correctCount = 0; // number of questions correctly answered

  // function that creates a new div and writes it to the output screen at end of quiz
  function updateFinalResultsScreen(answerNumber, correctAnswerNum) {
    var thisQuestion = theQuiz.questions[questionNum];
    var newResLine1 = "<div class='container'><hr><span class='alignleft'>";
    newResLine1 = newResLine1.concat(questionNum+1);
    newResLine1 = newResLine1.concat(". ");
    newResLine1 = newResLine1.concat(thisQuestion.question_text);

    if (thisQuestion.explanation != null) {
      newResLine1 = newResLine1.concat("</br><span style='color:#808080'>");
      newResLine1 = newResLine1.concat(thisQuestion.explanation);
      newResLine1 = newResLine1.concat('</span>');
    }

    // store the text of the given answer or a timeout message if the timer ran out
    var givenAnswer = (answerNumber == 5) ? "<i class=\"fa fa-clock-o\" aria-hidden=\"true\"> </i> Timeout" 
                                          : thisQuestion.answers[answerNumber].answer_text;

		
    if (answerNumber == correctAnswerNum) {
      var newResline2 = "</span><span class='aligncenterleft' style='color:green;'>"; 
      newResline2 = newResline2.concat(givenAnswer);
      var newResline3 = "</span><span class='alignright' style='color:green;'>+";
      newResline3 = newResline3.concat(thisQuestion.score);
      var newResline4 = "&nbsp;&nbsp;&nbsp;</span></br></div>";
    } else {
      var newResline2 = "</span><span class='aligncenterleft' style='color:red;'>";
      newResline2 = newResline2.concat(givenAnswer);
      var newResline3 = "</span><span class='alignright' style='color:red;'>";
      newResline3 = newResline3.concat("0");
      var newResline4 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></br></div>";
    }

    var newResLineAnswer = "</span><span class='aligncenterright'>";
    newResLineAnswer = newResLineAnswer.concat(thisQuestion.answers[correctAnswerNum].answer_text);
    var resultsTable = document.getElementById('quizResults'); 
    resultsTable.innerHTML = resultsTable.innerHTML + newResLine1 + newResline2 + newResLineAnswer + newResline3 + newResline4;
  }

  function displayQuestionSummary(percentages, answerNumber, correctAnswerNum) {
    var modalAnswers = [document.getElementById("popupAns1"), document.getElementById("popupAns2"),
                        document.getElementById("popupAns3"), document.getElementById("popupAns4")];
    var theAnswers = theQuiz.questions[questionNum].answers;

    // color correct answer green, user selection bold
    modalAnswers[correctAnswerNum].style.color = "#00933B";
    if (answerNumber != 5) {
      modalAnswers[answerNumber].style.fontWeight = "bold"; 
    }

    // display results modal
    $('#results').modal({ backdrop: 'static',keyboard: false });
    for (var i = 0; i < modalAnswers.length; i++) {
      modalAnswers[i].innerHTML = (theAnswers[i].answer_text + " (" + percentages[i] + "%)");
    }

    if (answerNumber == correctAnswerNum) {
      $("#title").html("<h3 style='color:green; display:inline;'>Correct (+" + score + " pts)</h3>");
      $('#results').modal('show');
    } else {
      if (answerNumber == 5) {
        $("#title").html("<h3 style='color:red; display:inline;'>You Ran Out of Time (+0 pts)</h3>");
      } else {
        $("#title").html("<h3 style='color:red; display:inline;'>Incorrect (+0 pts)</h3>");
      }
    }    
  }

  function submitAnswer(answerNumber) {
    clearTimeout(timerId);    // stop the timer

    //alert("Placeholder for question results.");
    var thisQuestion = theQuiz.questions[questionNum];
    var correctAnswerNum = -1;
    var totalAnswers = 1;     // start at one to account for the answer just submitted
    var percentages = [];
    for (var i = 0; i < thisQuestion.answers.length; i++) {
      totalAnswers += parseInt(thisQuestion.answers[i].times_chosen);
      if (thisQuestion.answers[i].correct_flag == "Y") {
        correctAnswerNum = i;
      }
    }

    // increment correct count and score if necessary
    correctCount = (correctAnswerNum == answerNumber) ? correctCount + 1 : correctCount;
    score = (correctAnswerNum == answerNumber) ? score + parseInt(thisQuestion.score) : score;

    for (var i = 0; i < thisQuestion.answers.length; i++) {
      // add one to times chosen if this was the answer chosen this time - will update the database later
      var timesChosen = parseInt(thisQuestion.answers[i].times_chosen);
      timesChosen = (i == answerNumber) ? timesChosen + 1 : timesChosen;
      //alert(timesChosen);
      percentages[i] = Math.round((timesChosen / totalAnswers) * 100);
      percentages[i] = (isNaN(percentages[i]) || percentages[i] < 0) ? 0 : percentages[i]; // set to 0 if NaN or negative
    }

    //alert(percentages);
		
    updateFinalResultsScreen(answerNumber, correctAnswerNum);
    displayQuestionSummary(percentages, answerNumber, correctAnswerNum);
    questionNum++;
  }

  function displaySummaryStats() {
    var correctString = "";
    correctString = correctString.concat(correctCount);
    correctString = correctString.concat(" out of ");
    correctString = correctString.concat(theQuiz.questions.length);
    correctString = correctString.concat(" questions correct!");

    document.getElementById('correctBox').innerHTML = correctString;
    var scoreString = "You scored ";
    scoreString = scoreString.concat(score);                   
    scoreString = scoreString.concat(" points!");
    document.getElementById('pointsBox').innerHTML = scoreString
  }

  function updateScreenForQuestion() {
    var thisQuestion = theQuiz.questions[questionNum];
    $("#question").html((questionNum + 1) + ") " + thisQuestion.question_text);
    $("#answer1").html(thisQuestion.answers[0].answer_text);
    $("#answer2").html(thisQuestion.answers[1].answer_text);
    $("#answer3").html(thisQuestion.answers[2].answer_text);
    $("#answer4").html(thisQuestion.answers[3].answer_text);
  }

  function updateTimer() {
    timeLeft -= 1;
    console.log("In updateTimer timer: Time left: " + timeLeft);
    $("#timer").html("<p>" + timeLeft + "</p>");

    if (timeLeft <= 0) {
      clearTimeout(timerId);
      submitAnswer(5);        // not a valid answer
    }
  }

  // get time per question and update the timer area.
  function setUpTimer() {
    timeLeft = parseInt(theQuiz.time_per_question);
    console.log("In setup timer: Time left: " + timeLeft);

    if (timeLeft == 0) {
      // no time chosen
      $("#timer").html("<p>&#x221E;</p>");
    } else {
      $("#timer").html("<p>" + timeLeft + "</p>"); // start timer at max
      // set up the timer
      timerId = setInterval(updateTimer, 1000); // 1 second interval
    }
  }

  function runQuestion() {
    $("#getready").modal('hide');

    // cancel the timer on new question 
    try {
      clearTimeout(timerId); 
    }
    catch(err){ }

    if (questionNum < theQuiz.questions.length) {
      setUpTimer();
      updateScreenForQuestion();
    } else {
      document.getElementById('content').innerHTML = "";
      displaySummaryStats();
      $('#quizResults').show();
    }
  }
 
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

  // function that determines which modal to show upon quiz selection
  function displayGetReadyDialog() {    
    if (theQuiz.questions.length > 0) {
      $("#getready").modal({ backdrop: 'static', keyboard: false });

      // update the messages on the get ready dialog according to data retrieved
      $("#num_questions").html((theQuiz.questions.length == 1) ? 
          "Found " + 1 + " question!" : 
          "Found " + theQuiz.questions.length + " questions!");
      $("#time_per_question").html(theQuiz.time_per_question == 0 ? 
          "You have unlimited time per question to choose the correct answer." : 
          "You have " + theQuiz.time_per_question + " seconds per question to choose the correct answer.");
    }
    else {
      $("#no_questions").modal({ backdrop: 'static', keyboard: false });
    }
  }

  function runNextQuestion() {
    $('#results').modal('hide');
    var popAns1 = document.getElementById('popupAns1');
    var popAns2 = document.getElementById('popupAns2');
    var popAns3 = document.getElementById('popupAns3');
    var popAns4 = document.getElementById('popupAns4');
    //Set all of the styles back to normal
    popAns1.style.color = "#f44336";
    popAns2.style.color = "#f44336";
    popAns3.style.color = "#f44336";
    popAns4.style.color = "#f44336";
    popAns1.style.fontWeight = "normal";
    popAns2.style.fontWeight = "normal";
    popAns3.style.fontWeight = "normal";
    popAns4.style.fontWeight = "normal";
    runQuestion();
  }


  $(document).ready(function() {
    // register the click event handlers
    $("#answer1").on("click", function() {
      submitAnswer(0);
    });
    $("#answer2").on("click", function() {
      submitAnswer(1);
    });
    $("#answer3").on("click", function() {
      submitAnswer(2);
    });
    $("#answer4").on("click", function() {
      submitAnswer(3);
    });
    $("#nextquestionbutton").on("click", function() {
      runNextQuestion();
    });

    var quiz_id = getParameterByName("quiz");
    var num_questions = getParameterByName("number");
    var timed = getParameterByName("timed");
    var mine = getParameterByName("mine");

    // build an object out of the data we need to send via ajax
    var postData = {
      "quiz": quiz_id,
      "timed": timed,
      "number": num_questions
    };

    // only send the mine data if it was set
    if (mine) {
      postData.mine = mine;
    }

    // go get the quiz
    $.ajax({
      type: "POST",
      url: "get_quiz.php",
      data: postData,
      dataType: "text",
      success: function(data) {
        console.log(data);
        theQuiz = JSON.parse(data);
        
        displayGetReadyDialog();
      },
      error: function(jqXHR, textStatus, error) { }
    });
  });

</script>
<?php include("../includes/footer.php"); ?>