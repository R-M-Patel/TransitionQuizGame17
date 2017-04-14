<?php session_start(); ?>
<?php require_once("../includes/db_connection.php") ?>
<?php require_once("../includes/functions.php"); ?>
<?php confirm_login_status(); ?>
<?php include("../includes/header.php"); ?>

<script src="static/js/jquery.easing.min.js"></script>

</head>
<body id="main">
  <?php echo get_navbar(); ?>

  <br><br><br><br>
  <div class="container" id="content">
    <div class="container text-center-element pos-rel-element">
      <h4 id="question" class="text-center-element"></h4>
    </div>

    <!-- Bowen - This DIV is always shown, but the below DIVs are set to modal (can't click out of), so this section is effectively hidden when another section is shown -->
    <!--Quiz-->
    <font size=5>
      <div class="container">
        <div class="large-lg-12 text-center">
          <img id="img" src="" class="smaller-image img-rounded text-center-element"></img>
        </div><br/>

        <div class="col-lg-3"></div>
        <div class="col-lg-3 text-center-element pos-rel-element">
          <button id="answer1" type="submit" name="userAnswer" value=1 class="btn btn-danger submit-a-button"></button><br/><br/>
        </div>
        <div class="col-lg-3 text-center-element pos-rel-element">
          <button id="answer2" type="submit" name="userAnswer" value=2 class="btn btn-info submit-a-button"></button><br/><br/>
        </div>
        <div class="col-lg-3"></div>
      </div>
      <div class="container">
        <div class="col-lg-3"></div>
        <div class="col-lg-3 text-center-element pos-rel-element">
          <button id="answer3" type="submit" name="userAnswer" value=3 class="btn btn-success submit-a-button"></button><br/><br/>
        </div>
        <div class="col-lg-3 text-center-element pos-rel-element">
          <button id="answer4" type="submit" name="userAnswer" value=4 class="btn btn-warning submit-a-button"></button>
        </div>
        <div class="col-lg-3"></div>
      </div>
      <button type="hidden submit" id="submit" name="userAnswer" class="hidden-element" value=0></button>
    </font>

    <!-- &#x221E == The Infinity Symbol -->
    <div class="container text-center-element" id="timer"><p>&#x221E;</p></div>
    <div class="container text-center-element"><h4 class="inline-element" id="counter"></h4></div>
  </div>

  <!--Get Ready Modal-->
  <!-- display this when the quiz is ready to begin -->
  <div class="modal fade modal-z" id="getready" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header text-center-element">
            <h1 class="inline-element">Are You Ready?</h1>
        </div>
        <div class="modal-body text-center-element">
          <span id="num_questions">Questions Found!</span><br/>
          <br><button class="btn btn-success round-border" onclick="runQuestion()" id="gobutton"><h2 class="link-button">Start</h2></button><br>
          <br/><span id="time_per_question"></span><br>
          <a href="index.php"><h5 class="inline-element"><br>Return Home</h5></a>
          <br>
        </div>
      </div>
    </div>
  </div>

  <!--No Questions Modal-->
  <!-- display this when there were no questions in the quiz -->
  <div class="modal fade modal-z" id="no_questions" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header text-center-element">
          <h1 class="inline-element">No Questions Found!</h1>
        </div>
        <div class="modal-body text-center-element">
          <br><a href="submit_new.php" class="btn btn-info round-border"><h2 class="link-button">Submit New Questions</h2></a><br>
          <br><a href="review_new_questions.php" class="btn btn-warning round-border"><h2 class="link-button">Review New Questions</h2></a><br>
          <br/><span> Questions must have a user rating of 5 or administrative permission to be active. </span><br>
          <a href="index.php"><h5 class="inline-element"><br>Return Home</h5></a>
          <br>
        </div>
      </div>
    </div>
  </div>

  <!-- Bowen - this DIV is shown when when the question is answered. 
       Then hidden once the Next Question button is clicked - see runNextQuestion function -->
  <!--Results Modal-->
  <div class="modal fade" data-keyboard="false" data-backdrop="static" id="results" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header text-center-element" id="title">
            <span id="popupHead"></span>
        </div>
        <div class="modal-body">
          <div id="results-div">
            <h3 class="inline-element">Results: </h3>
            <ol id="list">
              <li class="answer-list" id='popupAns1'></li>
              <li class="answer-list" id='popupAns2'></li>
              <li class="answer-list" id='popupAns3'></li>
              <li class="answer-list" id='popupAns4'></li>
            </ol>
            <h3 class="inline-element">Explanation: </h3>
            <p id='explanation'></p>
          </div>
        </div>
        <div class="modal-footer">
          <button id="upvote" class="btn btn-success pull-left" data-toggle="tooltip" title="Upvote this question.">
            <i class="fa fa-thumbs-up fa-2x" aria-hidden="true"></i>
          </button>
          <button id="downvote" class="btn btn-danger pull-left" data-toggle="tooltip" title="Downvote this question.">
            <i class="fa fa-thumbs-down fa-2x" aria-hidden="true"></i>
          </button>
          <p class="pull-left inline-element result-footer" id="numVotes"></p>
          <p class="text-center result-footer result-report" id="reportsent">Report Sent</p>
          <p class="text-center result-footer result-report" id="isreported">Already Reported</p>
          <button class="btn btn-info" id="report" data-toggle="tooltip" title="Report this question to admins.">
            <i class="fa fa-flag fa-2x" aria-hidden="true"></i>
          </button>
          <button class="btn btn-primary text-right" id="nextquestionbutton">Next Question</button>
          <div id="reset-vote-div">
          <button id="resetvote" class="btn btn-link pull-left fa" data-toggle="tooltip" title="Reset Vote.">
            Reset Vote
          </button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Bowen - this div is shown when the user clicks the flag button (see id="report" in Results modal). 
       Then hidden in sendReport() function -->
  <!--Report Modal-->
  <div class="modal fade modal-z" id="sendreport" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5>Report Question</h5>
        </div>
        <div class="modal-body">
            Describe the problem:<br><br>
          <textarea class="form-control" rows="3" cols="40" id="comment" name="comment" maxlength="350" required ></textarea>
          <br>
          <div id="reporterror"><p>You must supply a reason for report.</p></div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-default text-right" id="close_report">Close</button>
          <button class="btn btn-primary" id="send_report">Submit</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Bowen - this div is displayed at the end of the quiz (shown when counter = number of questions -->
  <div class="container text-center-element" id="quizResults">
    <div class="container">
      <h2 id="correctBox" class="text-center-element"></h2>
      <h4 id="pointsBox" class="text-center-element"></h4>
      <div class="col-sm-6">
        <a href="javascript:window.location.href=window.location.href" class="btn btn-success round-border">
          <h3 class="link-button">Play Again</h3>
        </a><br><br>
      </div>
      <div class="col-sm-6">
        <a href="select_quiz.php" class="btn btn-info round-border">
          <h3 class="link-button">Quiz Select</h3>
        </a><br/><br/>
      </div>
      <span class="alignleft">Question</span>
      <span class="aligncenterleft">Your Answer</span>
      <span class="aligncenterright">Correct Answer</span>
      <span class="alignright">Points&nbsp;</span>
      <br><br>
    </div>
  </div>

<script src="../public/static/js/take_quiz.js"></script>
<?php include("../includes/footer.php"); ?>