<?php require_once("../includes/functions.php") ?>
<?php include("../includes/header.php") ?>
<?php $username = "mjb236"; ?>
<?php $admin = false; ?>

<body id="page-top" data-spy="scroll" data-target=".navbar-fixed-top">
  <homebody>
    <!-- <homebody> -->
    <!-- Navigation -->
    <?php echo get_navbar($username, $admin); ?>
    <!-- Intro Header -->
    <header id="top" class="intro">
        <div class="intro-body">
            <div style="position:relative" id="description" class="col-md-8 col-md-offset-2">
                <h1 class="brand-heading">PharmGenius</h1>
                <p class="intro-text">An easy, fun way to help pharmacy
                students learn and study.<br>Get started now!</p>

                <?php echo get_play_button_display($username) ?>

            </div>
            <div id="dropdown" class="container col-xs-8 col-xs-offset-2 take-quiz">
                <form action="/takeQuiz">
                    <div class="container col-xs-12">
                        <a id ="on-back">
                            <i style="color:white; cursor:pointer; fontWeight:bold" class="fa fa-arrow-left animated fa-3x">&nbsp;<h1 style='display:inline'>Go Back</h1></i>
                        </a>
                        <br><br>
                    </div>
                    <div class="container col-xs-12">
                      <div class="col-sm-6 quiz-text">
                        Select a Category:
                      </div>
                      <div class="col-sm-6 quiz-select">
                        <select style="color:black" id="category" name="category" method="POST"><!--maybe pull in all categories from python-->
                        </select>
                        <br><br>
                      </div>
                      <div class="col-sm-6 quiz-text">
                        Select a Subcategory:
                      </div>
                      <div class="col-sm-6 quiz-select">
                        <select style="color:black" id="subcategory" name="subcategory" method="POST"><!--maybe pull in all categories from python-->
                        </select>
                        <br><br>
                      </div>
                      <div class="col-sm-6 quiz-text">
                        Number of Questions:
                      </div>
                      <div class="col-sm-6 quiz-select">
                          <select style="color:black" id="number" name="number" method="POST">
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
                          <select style="color:black" id="timed" name="timed" method="POST">
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
                          <input type="checkbox" name="mine" value="mine" style="font-size:1.5em;">
                          <br><br>
                        </div>
                        <button style="color:black" type='submit' id="startQuiz">Start Quiz</button>
                    </div>
                </form>
            </div>
        </div>
    </header>
  </homebody>

<?php include("../includes/footer.php") ?>
