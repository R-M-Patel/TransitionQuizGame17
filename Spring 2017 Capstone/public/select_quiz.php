<?php session_start(); ?>
<?php require_once("../includes/db_connection.php"); ?>
<?php require_once("../includes/functions.php"); ?>
<?php confirm_login_status(); ?>
<?php include("../includes/header.php"); ?>

<script src="static/js/dropdowns.js"></script>
</head>

<body id="page-top" class="main-page-body" data-spy="scroll" data-target=".navbar-fixed-top">
  <homebody>
    <!-- <homebody> -->
    <!-- Navigation -->
    <?php echo get_navbar(); ?>
    <!-- Intro Header -->
    <header id="top" class="intro">
      <div class="intro-body">
        <div id="dropdown" class="container col-xs-8 col-xs-offset-2"> <!-- Took "take-quiz" out of the class. could not get it to unhide -->
          <form action="../public/take_quiz.php" method="GET">
            <div class="container col-xs-12">
              <a href="index.php" id ="on-back">
                <i class="fa fa-arrow-left animated fa-3x white-link">&nbsp;<h1 class="inline-element">Go Back</h1></i>
              </a>
              <br><br>
            </div>
            <div class="container col-xs-12">
              <?php echo get_initial_dropdowns(); ?>
              <div class="col-sm-6 quiz-text">
                Number of Questions:
              </div>
              <div class="col-sm-6 quiz-select">
                <select class="black-text" id="number" name="number" method="GET">
                  <option value=5>5</option>
                  <option value=10>10</option>
                  <option value=15>15</option>
                  <option value=20>20</option>
                  <option value=25>25</option>
                  <option value=30>30</option>
                </select>
                <br><br>
              </div>
              <div class="col-sm-6 quiz-text">
                Seconds per Question:
              </div>
              <div class="col-sm-6 quiz-select">
                <select class="black-text" id="timed" name="timed" method="GET">
                  <option value=0>Unlimited</option>
                  <option value=5>5</option>
                  <option value=10>10</option>
                  <option value=15>15</option>
                  <option value=20>20</option>
                  <option value=25>25</option>
                  <option value=30>30</option>
                </select>
                <br><br>
              </div>
              <div class="col-sm-6 quiz-text">Only your Questions:</div>
              <div class="col-sm-6 quiz-select">
                <input type="checkbox" name="mine" value="mine">
                <br><br>
              </div>
              <button class="black-text" type='submit' id="startQuiz">Start Quiz</button>
            </div>
          </form>
        </div>
      </div>
    </header>
  </homebody>
<?php include("../includes/footer.php") ?>