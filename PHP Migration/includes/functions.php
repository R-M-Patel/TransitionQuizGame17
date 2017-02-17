<?php  

// **************************************************
// NAVBAR FUNCTIONS
//
// NOTE: PATHS WILL NEED UPDATED WHEN DEPLOYING - 
//       TO SPECIFY HOME DIRECTORY
// **************************************************

// get the navbar for the correct context
function get_navbar($username, $admin) {
  $html = navbar_open();
  if (isset($username) && !empty($username)) {
    $html .=  user_navbar($username, $admin);
  } else {
    $html .= simple_navbar();
  }
  $html .= navbar_close();

  return $html;
}

// get the opening section of the navbar
function navbar_open() {
  $html = "<nav class = \"navbar navbar-inverse navbar-fixed-top\" style=\"height: auto;\">";
  $html .= "<div class = \"container\">";
  $html .= "<div class=\"navbar-header\">";
  $html .= "<img src=\"../public/static/img/logo.png\" class=\"logo\" width=\"30\" height=\"30\" alt=\"\"/>";
  $html .= "<a href=\"../public/index.php\" class=\"navbar-brand\">PharmGenius</a>";
  $html .= "<button class = \"navbar-toggle\" data-toggle= \"collapse\" data-target = \".navHeaderCollapse\">";
  $html .= "<span class=\"icon-bar\"></span>";
  $html .= "<span class=\"icon-bar\"></span>";
  $html .= "<span class=\"icon-bar\"></span>";
  $html .= "</button>";
  $html .= "</div>";
  $html .= "<div class = \"collapse navbar-collapse navHeaderCollapse\">";
  $html .= "<ul class = \"nav navbar-nav navbar-right\">";

  return $html;
}

// get the closing section of the navbar
function navbar_close() {
  $html = "</ul></div></div></nav>";
  return $html;
}

// get the admin section of the navbar
function admin_navbar() {
  $html = "<li><a href=\"../public/reviewCategories.php\" id=\"reviewCats\" class=\"nav-button\">View Category Database</a></li>";
  return $html;
}

// get the user section of the navbar
function user_navbar($username, $admin) {
  $html = "<li><a href=\"../public/play.php\" id=\"quizme\" class=\"nav-button\">Quiz Me!</a></li>";
  $html .= "<li><a href=\"../public/leaderboard.php\" id=\"leaderboard\" class=\"nav-button\">Leaderboard</a></li>";
  $html .= "<li class=\"dropdown\">";
  $html .= "<a href=\"\" class=\"dropdown-toggle\" data-toggle=\"dropdown\"><span>Questions&nbsp;</span><b class=\"caret\"></b></a>";
  $html .= "<ul class=\"dropdown-menu\">";
  $html .= "<li><a href=\"../public/review_my_questions.php\" id=\"myQuestions\">Your Questions</a></li>";
  $html .= "<li><a href=\"../public/submit_new.php\" id=\"submitNew\">Submit A Question</a></li>";
  $html .= "<li><a href=\"../public/review_new_questions\" id=\"ReviewNew\" class=\"nav-button\">Review New Questions</a></li>";
  $html .= "<li><a href=\"../public/review_old_questions\" id=\"ReviewOld\" class=\"nav-button\">View Question Database</a></li>";

  if ($admin) {
    $html .= admin_navbar();
  }

  $html .= "</ul></li>";
  $html .= "<li class=\"dropdown\">";
  $html .= "<a href=\"../public/index.php\" class=\"dropdown-toggle\" data-toggle=\"dropdown\">";
  $html .= "<span class=\"profile-container\">";
  $html .= "<img src=\"../public/static/img/logo.png\" class=\"profile-small\" alt=\"\"/>&nbsp;&nbsp;Profile&nbsp;</span><b class=\"caret\" style=\"font-size:1.5em;\"></b></a>";
  $html .= "<ul class=\"dropdown-menu\">";
  $html .= "<li><a href=\"/profile?id={$username}\">View Profile</a></li>";
  $html .= "<li><a href=\"/send_bug_report.php\" data-toggle=\"modal\">Report a Bug</a></li>";
  $html .= "<li><a href=\"/logout.php\">Sign Out</a></li>";
  $html .= "</ul></li>";

  return $html;
}

// get the default navbar (not logged in)
function simple_navbar() {
  $html = "<li><a href=\"login.php\">Sign In</a></li>";

  return $html;
}

// **************************************************
// PLAY BUTTON FUNCTIONS
// **************************************************

// get the play button display depending on if user is logged in or not
function get_play_button_display($username) {
  if (isset($username) && !empty($username)) {
    return get_play_button();
  } else {
    return get_about_button();
  }
}

// get the button to play quiz if logged int
function get_play_button() {
  $html = "<a class=\"btn btn-circle\" id =\"on-play\">";
  $html .= "<i style=\"cursor:pointer; color:white; position: relative; left: 3px; top: -2px;\" class=\"fa fa-play animated\"></i></a>";

  return $html;
}

function get_about_button()  {
  $html = "<div id = \"play\">";
  $html .= "<a href=\"#about\" class=\"btn btn-circle page-scroll\">";
  $html .= "<i style=\"position: relative; left: -1px;\" class=\"fa fa-angle-double-down animated\"></i></a></div>";

  return $html;
}

?>