var theQuiz;            // will store our quiz data
var questionNum = 0;    // the current question number
var timeLeft = 0;       // the time remaining for this question
var timerId;            // the timer so we can start/stop it
var score = 0;          // score earned for the quiz
var correctCount = 0;   // number of questions correctly answered
var questionVotes = 0;  // the total vote value for the question
var userVote = 0;       // the value of the vote from the user for the question

// function that creates a new div and writes it to the output screen at end of quiz
function updateFinalResultsScreen(answerNumber, correctAnswerNum, questionScore) {
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
    newResline3 = newResline3.concat(questionScore);
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

// enable/disable vote buttons based on user's vote
function updateVoteButtons(userVoteValue) {
  // disable the vote buttons based on if the user has already voted
  if (userVoteValue == 1) {
    $("#upvote").prop("disabled", true);
    $("#downvote").prop("disabled", false);
  } else if (userVoteValue == -1) {
    $("#upvote").prop("disabled", false);
    $("#downvote").prop("disabled", true);
  } else  {
    $("#upvote").prop("disabled", false);
    $("#downvote").prop("disabled", false);
  }
}

// update the total vote number on the result modal
function updateVoteTotal(totalVoteValue) {
  $("#numVotes").html(totalVoteValue);
}

// display the summary modal in between questions
function displayQuestionSummary(percentages, answerNumber, correctAnswerNum, questionScore) {
  var modalAnswers = [document.getElementById("popupAns1"), document.getElementById("popupAns2"),
                      document.getElementById("popupAns3"), document.getElementById("popupAns4")];
  var theAnswers = theQuiz.questions[questionNum].answers;
  var userVoteValue = theQuiz.questions[questionNum].user_vote;

  // enable the report button if user has not already reported this question
  if (theQuiz.questions[questionNum].is_reported) {
    $("#report").prop("disabled", true);
    $("#report").css("cursor", "not-allowed");
    $("#isreported").css("display", "inline");
    $("#reportsent").css("display", "none");
  } else {
    $("#report").prop("disabled", false);
    $("#report").css("cursor", "default");
    $("#isreported").css("display", "none");
    $("#reportsent").css("display", "none");
  }
  updateVoteButtons(userVoteValue);    

  // color correct answer green, user selection bold
  modalAnswers[correctAnswerNum].style.color = "#00933B";
  if (answerNumber != 5) {
    modalAnswers[answerNumber].style.fontWeight = "bold"; 
  }

  // display results modal
  $('#results').modal({ backdrop: 'static',keyboard: false });
  updateVoteTotal(questionVotes);
  for (var i = 0; i < modalAnswers.length; i++) {
    modalAnswers[i].innerHTML = (theAnswers[i].answer_text + " (" + percentages[i] + "%)");
  }

  if (answerNumber == correctAnswerNum) {
    $("#title").html("<h3 style='color:green; display:inline;'>Correct! (+" + questionScore + " pts)</h3>");
    $('#results').modal('show');
  } else {
    questionScore = 0;
    if (answerNumber == 5) {
      $("#title").html("<h3 style='color:red; display:inline;'>You Ran Out of Time (+0 pts)</h3>");
    } else {
      $("#title").html("<h3 style='color:red; display:inline;'>Incorrect! (+0 pts)</h3>");
    }
  }    
}

// submits the users answer to the database
function submitAnswerToDatabase(answerNumber, correctAnswerNum, questionScore) {
  var answerFlag = (answerNumber == correctAnswerNum) ? "Y" : "N";

  var postData = {
    "action": "submit_answer",
    "question_id": theQuiz.questions[questionNum].question_id,
    "correct_flag": answerFlag,
    "score": questionScore,
    "answer_id": theQuiz.questions[questionNum].answers[answerNumber].answer_id
  };

  $.ajax({
    type: "POST",
    url: "../includes/ajax_calls.php",
    data: postData,
    dataType: "text",
    success: function(data) { }, // don't need to do anything else on success
    error: function(jqXHR, textStatus, error) { }
  });
}

// calculates the user's score for this question based on number of times the user
// has already answered this question correctly - rounds to nearest integer.
function calculateScore(baseScore, userCorrectAnswers) {
  return Math.round(baseScore * Math.pow(0.9, userCorrectAnswers));
}

// handle submission of the answer from the user
function submitAnswer(answerNumber) {
  clearTimeout(timerId);    // stop the timer

  var thisQuestion = theQuiz.questions[questionNum];
  var questionScore = 0;
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
  if (correctAnswerNum == answerNumber) {
    correctCount += 1;
    questionScore = calculateScore(parseInt(thisQuestion["score"]), parseInt(thisQuestion.user_correct_answers));
  }
  score += questionScore;

  for (var i = 0; i < thisQuestion.answers.length; i++) {
    // add one to times chosen if this was the answer chosen this time - will update the database later
    var timesChosen = parseInt(thisQuestion.answers[i].times_chosen);
    timesChosen = (i == answerNumber) ? timesChosen + 1 : timesChosen;
    percentages[i] = Math.round((timesChosen / totalAnswers) * 100);
    percentages[i] = (isNaN(percentages[i]) || percentages[i] < 0) ? 0 : percentages[i]; // set to 0 if NaN or negative
  }

  // do not need to update the database if there was a timeout
  if (answerNumber != 5) {
    submitAnswerToDatabase(answerNumber, correctAnswerNum, questionScore);
    updateTimesAnswerChosen(answerNumber);
  }  
  updateFinalResultsScreen(answerNumber, correctAnswerNum, questionScore);
  displayQuestionSummary(percentages, answerNumber, correctAnswerNum, questionScore);
  questionNum++;
}

// increment the number of times this answer was chosen
function updateTimesAnswerChosen(answerNumber) {
  var postData = {
    "action": "update_times_chosen",
    "answer_id": theQuiz.questions[questionNum].answers[answerNumber].answer_id,
  };

  $.ajax({
    type: "POST",
    url: "../includes/ajax_calls.php",
    data: postData,
    dataType: "text",
    success: function(data) { }, // don't need to do anything else on success
    error: function(jqXHR, textStatus, error) { }
  });
}

// display the stats at the end of the quiz
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

// update the quiz screen for the current question
function updateScreenForQuestion() {
  var thisQuestion = theQuiz.questions[questionNum];
  $("#question").html((questionNum + 1) + ") " + thisQuestion.question_text);
  $("#answer1").html(thisQuestion.answers[0].answer_text);
  $("#answer2").html(thisQuestion.answers[1].answer_text);
  $("#answer3").html(thisQuestion.answers[2].answer_text);
  $("#answer4").html(thisQuestion.answers[3].answer_text);
}

// function that the timer executes every second - will submit an answer of 5
// if the timer is up
function updateTimer() {
  timeLeft -= 1;

  $("#timer").html("<p>" + timeLeft + "</p>");

  if (timeLeft <= 0) {
    clearTimeout(timerId);
    submitAnswer(5);        // not a valid answer
  }
}

// get time per question and update the timer area.
function setUpTimer() {
  timeLeft = parseInt(theQuiz.time_per_question);

  if (timeLeft == 0) {
    // no time chosen
    $("#timer").html("<p>&#x221E;</p>");
  } else {
    $("#timer").html("<p>" + timeLeft + "</p>"); // start timer at max
    // set up the timer
    timerId = setInterval(updateTimer, 1000); // 1 second interval
  }
}

// run the question
function runQuestion() {
  $("#getready").modal('hide');

  // cancel the timer on new question 
  try {
    clearTimeout(timerId); 
  }
  catch(err){ }

  if (questionNum < theQuiz.questions.length) {
    questionVotes = parseInt(theQuiz.questions[questionNum].total_vote_value);  // store vote values
    userVote = parseInt(theQuiz.questions[questionNum].user_vote);              // store user vote value
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

// send the user's vote to the database
function submitVoteToDatabase(value, question_id) {
  var postData = {
    "action": "submit_vote",
    "question_id": question_id,
    "value": value
  };

  $.ajax({
    type: "POST",
    url: "../includes/ajax_calls.php",
    data: postData,
    dataType: "text",
    success: function(data) { }, // don't need to do anything else on success
    error: function(jqXHR, textStatus, error) { }
  });
}

// reset styles and run the next question
function runNextQuestion() {
  // submit vote if there was a change
  // note that we have already incremented question num - need to look at previous question
  if (userVote != theQuiz.questions[questionNum - 1].user_vote) {
    submitVoteToDatabase(userVote, theQuiz.questions[questionNum - 1].question_id);
  }

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

// updates the display of the votes - vote change not submitted to database
// until user chooses to go to next question
function updateVote(value) {
  if (value == 0) {
    questionVotes -= userVote;  // remove user current vote from votes
    userVote = 0;               // reest to 0
  } else {
    questionVotes += value;     // add the user's vote. will add a negative number if user voted down
    userVote += value;
  }    

  updateVoteTotal(questionVotes);
  updateVoteButtons(userVote);
}

// displays the report modal and hides the results
function displayReportModal() {
  $('#sendreport').modal({ backdrop: 'static',keyboard: false });
  $("#results").modal("hide");
  $("#sendreport").modal("show");
}

// closes the report modal and reshows the results.
function closeReportModal() {
  $("#results").modal("show");
  $("#sendreport").modal("hide");
}

// send the report
function sendReport() {
  var comment = $("#comment").val();

  if (comment.length >= 3) {
    var postData = {
      "action": "submit_report",
      "question_id": parseInt(theQuiz.questions[questionNum - 1].question_id),
      "problem_text": comment
    };

    console.log(postData);

    $.ajax({
      type: "POST",
      url: "../includes/ajax_calls.php",
      data: postData,
      dataType: "text",
      success: function(data) { }, // don't need to do anything else on success
      error: function(jqXHR, textStatus, error) { }
    });

    $("#report").prop("disabled", true);
    $("#report").css("cursor", "not-allowed");
    $("#reportsent").css("display", "inline");
    closeReportModal();
  } else {
    // display error
    $("#reporterror").css("display", "block");
  }
}

// on document ready, register events and get the quiz from the database
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
  $("#upvote").on("click", function() {
    updateVote(1);
  });
  $("#downvote").on("click", function() {
    updateVote(-1);
  });
  $("#resetvote").on("click", function() {
    updateVote(0);
  });
  $("#report").on("click", function() {
    displayReportModal();
  });
  $("#close_report").on("click", function() {
    closeReportModal();
  });
  $("#send_report").on("click", function() {
    sendReport();
  });
  $("#comment").on("keypress", function() {
    if ($("#comment").val().length >= 2) {
      $("#reporterror").css("display", "none");
    }
  });  

  var quiz_id = getParameterByName("quiz");
  var num_questions = getParameterByName("number");
  var timed = getParameterByName("timed");
  var mine = getParameterByName("mine");

  // build an object out of the data we need to send via ajax
  var postData = {
    "action": "get_quiz",
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
    url: "../includes/ajax_calls.php",
    data: postData,
    dataType: "text",
    success: function(data) {
      theQuiz = JSON.parse(data);
      
      displayGetReadyDialog();
    },
    error: function(jqXHR, textStatus, error) { }
  });
});