<?php session_start(); ?>
<?php require_once("../includes/db_connection.php"); ?>
<?php require_once("../includes/functions.php"); ?>
<?php 
  $username = "";

  // if user is logged in, no need to display page. redirect.
  if (is_logged_in()) {
    redirect_to("../public/index.php");
  }

  // process the form if needed
  if (isset($_POST["submit"])) {
    // process form
    $username = $_POST["username"];
    $password = $_POST["password"];
    $user = attempt_login($username, $password);

    // if user was found and valid, set session variables and redirect to index
    if ($user) {
      if ($user["active_flag"] == "N") {
        $_SESSION["message"] = "Your account is inactive. Unable to log in.";
      } else {
        $_SESSION["message"] = null;
        $_SESSION["username"] = $user["username"];
        $_SESSION["active_flag"] = $user["active_flag"];
        $_SESSION["admin_flag"] = $user["admin_flag"];
        $_SESSION["owner_flag"] = $user["owner_flag"];
        redirect_to("../public/index.php");
      }
    }
    else {
      // no user found
      $_SESSION["message"] = "Username/password incorrect.";
    }
  }
?>
<?php include("../includes/header.php"); ?>

</head>
<body id="page-top" class="main-page-body" data-spy="scroll" data-target=".navbar-fixed-top">
  <homebody>
    <!-- <homebody> -->
    <!-- Navigation -->
    <?php echo get_navbar(); ?>
    <!-- Intro Header -->
    <header id="top" class="intro">
      <div class="intro-body">
      <?php 
        $message = get_session_message(); 
        if (isset($message)) { 
            echo htmlentities($message) . "<br /><br />";
        } 
      ?>

        <div id="dropdown" class="container col-xs-8 col-xs-offset-2"> <!-- Took "take-quiz" out of the class. could not get it to unhide -->
          <form action="login.php" method="post">
            <div class="container col-xs-12">
              <h1 class="inline-element">Log In</h1>
              <br><br><br><br>
            </div>
            <div class="container col-xs-12">
              <div class="col-sm-6 quiz-text">
                Username:
              </div>
              <div class="col-sm-6 quiz-select black-text">
                <input type="text" name="username" value="<?php echo htmlentities($username) ?>">
                <br><br>
              </div>
              <div class="col-sm-6 quiz-text">
                Password:
              </div>
              <div class="col-sm-6 quiz-select black-text">
              <input type="password" name="password">
                <br><br>
              </div>
              <button type="submit" name="submit" class="black-text" id="startQuiz">Log In</button>
            </div>
          </form>
          <hr class="hidden-element" /><br><br>&nbsp;&nbsp;
          <a href="create_account.php" id ="on-back">
            <i class="fa animated fa-3x white-link">&nbsp;<h1 class="inline-element">Create Account</h1></i>
          </a>
        </div>         
      </div>
    </header>
  </homebody>

<?php include("../includes/footer.php"); ?>