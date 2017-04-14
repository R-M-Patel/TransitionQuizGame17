<?php  

// **************************************************
// REDIRECT FUNCTION
//
// NOTE: This must be called before any HTML or
//       whitespace (i.e. before header sent)
// **************************************************

// redirect the user to a different page
function redirect_to($page) {
  header("Location: " . $page);
  exit;
}

// **************************************************
// NAVBAR FUNCTIONS
//
// NOTE: PATHS WILL NEED UPDATED WHEN DEPLOYING - 
//       TO SPECIFY HOME DIRECTORY
// **************************************************

// get the navbar for the correct context
function get_navbar() {
  $html = navbar_open();
  if (is_logged_in()) {
    // user is logged in - display user nav bar
    $html .=  user_navbar();
  } else {
    // user is not logged in, display lite navbar
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
  $html = "<li class=\"dropdown\">";
  $html .= "<a href=\"\" class=\"dropdown-toggle\" data-toggle=\"dropdown\"><span>Admin&nbsp;</span><b class=\"caret\"></b></a>";
  $html .= "<ul class=\"dropdown-menu\">";
  $html .= "<li><a href=\"../public/review_categories.php\" id=\"reviewCats\" class=\"nav-button\">View Category Database</a></li>";
  $html .= "<li><a href=\"../public/manage_users.php\" id=\"manageUsers\" class=\"nav-button\">Manage Users</a></li>";
  $html .= "</ul></li>";
  return $html;
}

// get the user section of the navbar
function user_navbar() {
  $html = "<li><a href=\"../public/select_quiz.php\" id=\"quizme\" class=\"nav-button\">Quiz Me!</a></li>";
  $html .= "<li><a href=\"../public/leaderboard.php\" id=\"leaderboard\" class=\"nav-button\">Leaderboard</a></li>";
  $html .= "<li class=\"dropdown\">";
  $html .= "<a href=\"\" class=\"dropdown-toggle\" data-toggle=\"dropdown\"><span>Questions&nbsp;</span><b class=\"caret\"></b></a>";
  $html .= "<ul class=\"dropdown-menu\">";
  $html .= "<li><a href=\"../public/review_my_questions.php\" id=\"myQuestions\">Your Questions</a></li>";
  $html .= "<li><a href=\"../public/submit_new.php\" id=\"submitNew\">Submit A Question</a></li>";
  $html .= "<li><a href=\"../public/review_new_questions.php\" id=\"ReviewNew\" class=\"nav-button\">Review New Questions</a></li>";
  $html .= "<li><a href=\"../public/review_old_questions.php\" id=\"ReviewOld\" class=\"nav-button\">View Question Database</a></li>";
  $html .= "</ul></li>";

  if (is_user_admin()) {
    $html .= admin_navbar();
  } 

  $html .= "<li class=\"dropdown\">";
  $html .= "<a href=\"../public/index.php\" class=\"dropdown-toggle\" data-toggle=\"dropdown\">";
  $html .= "<span class=\"profile-container\">";
  $html .= "<img src=\"";
  $image_url = get_image_url($_SESSION["username"]);
  $html .= ($image_url == null) ? "../public/static/img/logo.png\"" : "{$image_url}\" ";
  $html .= "class=\"profile-small\" alt=\"\"/>&nbsp;&nbsp;Profile&nbsp;</span><b class=\"caret\" style=\"font-size:1.5em;\"></b></a>";
  $html .= "<ul class=\"dropdown-menu\">";
  $html .= "<li><a href=\"../public/profile.php?id=";
  $html .= htmlentities($_SESSION["username"]); // add username to the profile page get request
  $html .= "\">View Profile</a></li>";
  $html .= "<li><a href=\"#sendbugreport\" data-toggle=\"modal\">Report a Bug</a></li>";
  $html .= "<li><a href=\"../public/logout.php\">Sign Out</a></li>";
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
function get_play_button_display() {
  if (is_logged_in()) {
    return get_play_button();
  } else {
    return get_about_button();
  }
}

// get the button to play quiz if logged in
function get_play_button() {
  $html = "<a href=\"select_quiz.php\" class=\"btn btn-circle\" id=\"on-play\">";
  $html .= "<i style=\"cursor:pointer; color:white; position: relative; left: 3px; top: -2px;\" class=\"fa fa-play animated\"></i></a>";

  return $html;
}

// show the button that directs to about (if user not logged in)
function get_about_button()  {
  $html = "<div id = \"play\">";
  $html .= "<a href=\"#about\" class=\"btn btn-circle page-scroll\">";
  $html .= "<i style=\"position: relative; left: -1px;\" class=\"fa fa-angle-double-down animated\"></i></a></div>";

  return $html;
}

// **************************************************
// DROPDOWN FUNCTIONS
// **************************************************

// gets html for the quiz selection drop downs - builds html for the
// category, then calls get_quiz_dropdown
function get_initial_dropdowns() {
  $html = "<div class=\"col-sm-6 quiz-text\">Select a Category:</div>";
  $html .= "<div class=\"col-sm-6 quiz-select\">";
  $html .= "<select style=\"color:black\" id=\"category\">";

  // get all active categories
  // true specifies only active categories
  $category_set = get_all_categories(true);
  
  while ($category = mysqli_fetch_assoc($category_set)) {
    $name = htmlentities($category["category_name"]);
    $id = htmlentities($category["category_id"]);
    if (!isset($quiz_dropdown)) {
      $quiz_dropdown = get_quiz_dropdown($id);
    }
    $html .= "<option value=\"{$id}\">{$name}</option>";
  }
  $html .= "</select><br /><br /></div>";

  if (isset($quiz_dropdown)) {
    $html .= $quiz_dropdown;
  }

  return $html;
}

// gets html for the quiz drop down
function get_quiz_dropdown($category_id) {
  $html = "<div class=\"col-sm-6 quiz-text\">Select a Quiz:</div>";
  $html .= "<div class=\"col-sm-6 quiz-select\">";
  $html .= "<select style=\"color:black\" id=\"quiz\" name=\"quiz\" method=\"GET\">"; 

  $quiz_set = get_quizzes_for_category($category_id, true);
   
  while ($quiz = mysqli_fetch_assoc($quiz_set)) {
    $name = htmlentities($quiz["quiz_name"]);
    $id = htmlentities($quiz["quiz_id"]);
    $html .= "<option value=\"{$id}\">{$name}</option>";
  }
  $html .= "</select><br /><br /></div>";

  return $html;
}

// **************************************************
// DATABASE HELPER FUNCTIONS
// **************************************************

// ensure query worked
function confirm_query($result_set) {
  if (!$result_set) {
      die("Database query failed.");
    }
}

// clean up string to prevent injections
function mysql_prep($string) {
    global $connection;
    
    $escaped_string = mysqli_real_escape_string($connection, $string);
    return $escaped_string;
  }

// **************************************************
// RETRIEVE DATA FUNCTIONS
// **************************************************

// find a user - return the user or null if not found
function find_user($username) {
  global $connection;

  $safe_username = mysql_prep($username);

  $query = "SELECT * ";
  $query .= "FROM user ";
  $query .= "WHERE username = '{$safe_username}' ";
  $query .= "LIMIT 1";

  $user_set = mysqli_query($connection, $query);
  confirm_query($user_set);
  if ($user = mysqli_fetch_assoc($user_set)) {
    return $user;
  } else {
    return null;
  }
}

// get all active categories
// if active_only is true, only active categories will be returned
function get_all_categories($active_only) {
  global $connection;

  $query = "SELECT category_id, category_name, active_flag, verified_flag ";
  $query .= "FROM category ";
  if ($active_only) {
      $query .= "WHERE active_flag = 'Y' ";
  }
  $query .= "ORDER BY category_name";

  $category_set = mysqli_query($connection, $query);
  confirm_query($category_set);

  return $category_set;
}


// get quiz_ids and quiz_names for specified category
// if active_only is true, only active quizzes will be returned
function get_quizzes_for_category($category_id, $active_only) {
  global $connection;

  $safe_category_id = mysql_prep($category_id);

  $query = "SELECT quiz_id, quiz_name ";
  $query .= "FROM quiz ";
  $query .= "WHERE category_id = {$safe_category_id} ";
  if ($active_only) {
      $query .= "AND active_flag = 'Y' ";
  }
  $query .= "ORDER BY quiz_name";

  $quiz_set = mysqli_query($connection, $query);
  confirm_query($quiz_set);

  return $quiz_set;
}

// This function will get any quiz by its quiz id
// NOTE: select_quiz.php should only display active quizzes
//       so when this function is called, the passed in quiz_id
//       should only be for an active quiz
function get_quiz($quiz_id) {
  global $connection;

  $safe_quiz_id = mysql_prep($quiz_id);

  $query = "SELECT quiz_id, quiz_name, description, created_by ";
  $query .= "FROM quiz ";
  $query .= "WHERE quiz_id = {$safe_quiz_id} ";
  $query .= "LIMIT 1";

  $quiz_set = mysqli_query($connection, $query);
  confirm_query($quiz_set);

  return quiz_set_to_array($quiz_set);
}

// takes a quiz_set result resource retrieved from the database and 
// changes it into an array with a blank array for storing the questions
function quiz_set_to_array($quiz_set) {
  // should only return one result
  if ($quiz = mysqli_fetch_assoc($quiz_set)) {
    $quiz["questions"] = array();
  } else {
    // get_quiz returned no results
    return null;
  }  

  return $quiz;
}

// get questions for the quiz
function get_questions_for_quiz($quiz_id, $num_questions, $username, $active_only) {
  global $connection;

  $safe_quiz_id = mysql_prep($quiz_id);
  $query = "SELECT question_id, question_text, score, explanation, times_answered, times_correctly_answered, created_by ";
  $query .= "FROM question ";
  $query .= "WHERE quiz_id = {$safe_quiz_id} ";
  if ($active_only) {
    $query .= "AND active_flag = 'Y' ";
  }
  if ($username != null) {
    $safe_user_name = mysql_prep($username);
    $query .= "AND created_by = '{$safe_user_name}' ";
  }

  $question_set = mysqli_query($connection, $query);
  confirm_query($question_set);

  return question_set_to_array($question_set, $num_questions);
}

// takes a question set and transforms it into an shuffled array of questions
// containing the specified number of questions
function question_set_to_array($question_set, $num_questions) {
  $questions = array(); //questions will be an array of arrays

  $i = 0;
  while ($question = mysqli_fetch_assoc($question_set)) {
    $question["answers"] = array();
    $questions[$i] = $question;
    $i++;
  }

  // shuffle the array
  shuffle($questions);

  return array_slice($questions, 0, $num_questions);
}

// get questions for the quiz
function get_answers_for_question($question_id) {
  global $connection;

  $safe_question_id = mysql_prep($question_id);
  $query = "SELECT answer_id, answer_text, correct_flag, times_chosen ";
  $query .= "FROM answer ";
  $query .= "WHERE question_id = {$safe_question_id} ";
  $query .= "LIMIT 4 "; // there should only be 4 anyway

  $answer_set = mysqli_query($connection, $query);
  confirm_query($answer_set);

  return answer_set_to_array($answer_set);
}

// returns the answers in an array that has been shuffled
function answer_set_to_array($answer_set) {
  $answers = array();

  $i = 0;
  while ($answer = mysqli_fetch_assoc($answer_set)) {
    $answers[$i] = $answer;
    $i++;
  }

  shuffle($answers);

  return $answers;
}

// submits the answer to the database
function submit_answer($question_id, $correct_flag, $username, $score, $answer_id) {
  global $connection;

  $safe_question_id = mysql_prep($question_id);
  $safe_correct_flag = mysql_prep($correct_flag);
  $safe_username = mysql_prep($username);
  $safe_score = mysql_prep($score);
  $safe_answer_id = mysql_prep($answer_id);

  $query = "INSERT INTO answer_log ";
  $query .= "(question_id, correct_flag, username, score, answer_id) ";
  $query .= "VALUES ({$safe_question_id}, '{$safe_correct_flag}', '{$safe_username}', {$safe_score}, {$safe_answer_id}) ";

  $answer_log_set = mysqli_query($connection, $query);
  confirm_query($answer_log_set);

  return $answer_log_set;
}

// increment the number of times the answer has been selected
function update_times_chosen($answer_id) {
  global $connection;

  $safe_answer_id = mysql_prep($answer_id);

  $query = "UPDATE answer ";
  $query .= "SET times_chosen = times_chosen + 1 ";
  $query .= "WHERE answer_id = {$safe_answer_id} ";

  $answer_set = mysqli_query($connection, $query);
  confirm_query($answer_set);

  return $answer_set;
}

// get the total vote value for this question
function get_vote_value_for_question($question_id) {
  global $connection;

  $safe_question_id = mysql_prep($question_id);

  $query = "SELECT value ";
  $query .= "FROM vw_questionVoteValue ";
  $query .= "WHERE question_id = {$safe_question_id} ";

  $vote_value_set = mysqli_query($connection, $query);
  confirm_query($vote_value_set);

  if ($vote_value = mysqli_fetch_assoc($vote_value_set)) {
    // query should only return one result
    return $vote_value["value"];
  } else {
    return 0; // return 0 by default (shouldn't happen)
  }
}

// get the current vote value that the given user has given 
// to the question - returns 0 if user has not yet voted
function get_vote_value_for_user($username, $question_id) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_question_id = mysql_prep($question_id);

  $query = "SELECT value ";
  $query .= "FROM votes ";
  $query .= "WHERE question_id = {$safe_question_id} and username = '{$safe_username}' ";

  $vote_value_set = mysqli_query($connection, $query);
  confirm_query($vote_value_set);

  if ($vote_value = mysqli_fetch_assoc($vote_value_set)) {
    return $vote_value["value"];
  } else {
    return 0; // return 0 by default (no rows)
  }
}

// get the number of attempts that this answer submission
// will be for the given user
function get_attempt_number($username, $question_id) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_question_id = mysql_prep($question_id);

  $query = "SELECT ifnull(max(attempt_number) + 1, 1) as attempt_number ";
  $query .= "FROM answer_log ";
  $query .= "WHERE question_id = {$safe_question_id} and username = '{$safe_username}' ";

  $attempt_set = mysqli_query($connection, $query);
  confirm_query($attempt_set);

  if ($attempt = mysqli_fetch_assoc($attempt_set)) {
    return $attempt["attempt_number"];    
  }
  return 0; // return 0 by default (no rows)
}

// get the number of times that the user has answered this question correctly
function get_correct_answer_count($username, $question_id) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_question_id = mysql_prep($question_id);

  $query = "SELECT count(*) as num_correct ";
  $query .= "FROM answer_log ";
  $query .= "WHERE question_id = {$safe_question_id} AND username = '{$safe_username}' ";
  $query .= "AND correct_flag = 'Y' ";

  $correct_set = mysqli_query($connection, $query);
  confirm_query($correct_set);

  if ($num_correct = mysqli_fetch_assoc($correct_set)) {
    return $num_correct["num_correct"];    
  }

  return 0; // return 0 by default (no rows)
}

// update the active_flag of the category
function update_category_active_flag($category_id, $active_flag) {
  global $connection;

  $safe_category_id = mysql_prep($category_id);
  $safe_active_flag = mysql_prep($active_flag);

  $query = "UPDATE category ";
  $query .= "SET active_flag = '{$safe_active_flag}' ";
  $query .= "WHERE category_id = {$safe_category_id} ";

  echo $query;

  $category_set = mysqli_query($connection, $query);
  confirm_query($category_set);

  echo $category_set;
}

// submit a vote to the database - note that we use a trick in this query
// we attempt to insert a new vote for the user if it does not exist.
// if one already exists, a unique index violation will occur - the 
// "ON DUPLICATE KEY" part of the query instructs the database to update
// the existing row if that were to occur - thus we will preserve only having
// one vote per user per question
function submit_vote($username, $question_id, $vote_value) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_question_id = mysql_prep($question_id);
  $safe_vote_value = mysql_prep($vote_value);

  $query = "INSERT INTO votes (username, question_id, value) ";
  $query .= "VALUES ('{$safe_username}', {$safe_question_id}, {$safe_vote_value}) ";
  $query .= "ON DUPLICATE KEY UPDATE value = {$safe_vote_value} ";

  $vote_set = mysqli_query($connection, $query);
  confirm_query($vote_set);

  return $vote_set;
}

function submit_report($username, $question_id, $problem_text) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_question_id = mysql_prep($question_id);
  $safe_problem_text = mysql_prep($problem_text);

  $query = "INSERT INTO flagged_questions (flagged_by_user, question_id, problem_text) ";
  $query .= "VALUES ('{$safe_username}', {$safe_question_id}, '{$safe_problem_text}') ";

  // $report_set = mysqli_query($connection, $query);
  // confirm_query($report_set);

  // return $report_set;
  if (mysqli_query($connection, $query)) {
    $subject = "PharmGenius: New Flagged Question";
    $message = get_report_email_text($safe_username, $safe_question_id, $problem_text);
    send_email("submit_report", $subject, $message);
    return "Success";
  } else {
    return "Failed - " . mysqli_error($connection);
  } 
}

// determine if the question has already been reported
function is_question_reported_by_user($username, $question_id) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_question_id = mysql_prep($question_id);
  
  $query = "SELECT flagged_question_id ";
  $query .= "FROM flagged_questions ";
  $query .= "WHERE flagged_by_user = '{$safe_username}' ";
  $query .= "AND question_id = {$safe_question_id} ";

  $report_set = mysqli_query($connection, $query);
  confirm_query($report_set);

  if ($reported = mysqli_fetch_assoc($report_set)) {
    return true;
  }

  return false;
}

// get relevant data for managing users
function get_user_data() {
  global $connection;

  $query = "SELECT u.username, u.score, p.full_name, p.year, u.admin_flag, u.active_flag, u.owner_flag, DATE_FORMAT(u.registered_date,'%m/%d/%Y') as registered_date ";
  $query .= "FROM user u ";
  $query .= "JOIN user_profile p on p.username = u.username ";
  $query .= "ORDER BY username ASC ";

  $user_set = mysqli_query($connection, $query);
  confirm_query($user_set);

  return $user_set;
}

// toggle the flag value for the given flag/user
function toggle_user_flag_status($flag, $new_value, $username) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_flag = mysql_prep($flag);
  $safe_flag_value = mysql_prep($new_value);

  $query = "UPDATE user ";
  $query .= "SET {$safe_flag} = '{$safe_flag_value}' ";
  $query .= "WHERE username = '{$safe_username}' ";

  if (mysqli_query($connection, $query)) {
    return "Success";
  } else {
    return "Failed - " . mysqli_error($connection);
  } 
}

// submit a bug to the database.
function submit_bug($report_text, $username) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_report_text = mysql_prep($report_text);

  $query = "INSERT INTO bug_report ";
  $query .= "(report_text, username) ";
  $query .= "VALUES ('{$safe_report_text}', '{$safe_username}') ";

  if (mysqli_query($connection, $query)) {
    $subject = "PharmGenius: New Bug Report";
    $message = "User {$safe_username} submitted the following bug/suggestion: {$safe_report_text}";
    send_email("submit_bug", $subject, $message);
    return "Success";
  } else {
    return "Failed - " . mysqli_error($connection);
  } 
}

// reset a user's score
function reset_user_score($username) {
  global $connection;

  $safe_username = mysql_prep($username);

  $query = "CALL sp_resetUserScore('{$safe_username}') ";

  $result = mysqli_query($connection, $query) or die("Query fail: " . mysqli_error());

  return $result;
}

// check to see if a username is available in the database
function check_username_availability($username) {
  global $connection;

  $safe_username = mysql_prep($username);
  
  $query = "SELECT registered_date ";
  $query .= "FROM user ";
  $query .= "WHERE username = '{$safe_username}' ";

  $user_set = mysqli_query($connection, $query);
  confirm_query($user_set);

  if ($user = mysqli_fetch_assoc($user_set)) {
    return "true";
  }

  return "false";
}

// check if the category already exists
function check_category_availability($category_text) {
  global $connection;

  $stripped_category = strtolower(preg_replace("/[^A-Za-z0-9]/", "", $category_text));

  $query = "SELECT category_name ";
  $query .= "FROM category ";

  $category_set = mysqli_query($connection, $query);
  confirm_query($category_set);

  while ($category = mysqli_fetch_assoc($category_set)) {
    if (strtolower(preg_replace("/[^A-Za-z0-9]/", "", $category["category_name"])) == $stripped_category) {
      return "true";
    }
  }

  return "false";
}

// check to see if the email address is available
function check_email_availability($email) {
  global $connection;

  //$safe_email = mysql_prep($email);
  
  $query = "SELECT registered_date ";
  $query .= "FROM user ";
  $query .= "WHERE email_address = '{$email}' ";

  $user_set = mysqli_query($connection, $query);
  confirm_query($user_set);

  if ($user = mysqli_fetch_assoc($user_set)) {
    return "true";
  }

  return "false";
}

// create a category in the database
function create_category($username, $category_text, $quiz_text) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_category_text = mysql_prep($category_text);
  $safe_quiz_text = mysql_prep($quiz_text);
  
  $query = "CALL sp_createCategoryAndQuiz('{$safe_username}', '{$safe_category_text}', '{$safe_quiz_text}') ";

  $result = mysqli_query($connection, $query) or die("Query fail: " . mysqli_error($connection));

  return $result;
}

// create a question in the database
function create_question($username, $question_text, $quiz_id, $explanation, $correct_answer, $answer1, $answer2, $answer3, $answer4) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_question_text = mysql_prep($question_text);
  $safe_quiz_id = mysql_prep($quiz_id);
  $safe_correct_answer = mysql_prep($correct_answer);
  $safe_explanation = mysql_prep($explanation);
  $safe_answer1 = mysql_prep($answer1);
  $safe_answer2 = mysql_prep($answer2);
  $safe_answer3 = mysql_prep($answer3);
  $safe_answer4 = mysql_prep($answer4);
  
  $query = "CALL sp_createQuestion('{$safe_username}', '{$safe_question_text}', {$safe_quiz_id}, '{$correct_answer}', ";
  $query .= "'{$safe_answer1}', '{$safe_answer2}', '{$safe_answer3}', '{$safe_answer4}', '{$safe_explanation}') ";

  $result = mysqli_query($connection, $query) or die("Query fail: " . mysqli_error($connection));

  return $result;
}

// create a quiz in the database
function create_quiz($username, $quiz_name, $category_id) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_quiz_name = mysql_prep($quiz_name);
  $safe_category_id = mysql_prep($category_id);

  $query = "INSERT INTO quiz (quiz_name, category_id, active_flag, removed_flag, created_by, last_updated_by) ";
  $query .= "VALUES ('{$safe_quiz_name}', '{$safe_category_id}', 'Y', 'N', '{$safe_username}', '{$safe_username}') ";

  $result = mysqli_query($connection, $query) or die("Query fail: " . mysqli_error($connection));

  return $result;
}

// **************************************************
// PROFILE FUNCTIONS
// **************************************************

// function to display user profile image if it exists
function get_profile_image_html($image_url) {
  $html = "<img src=";

  if (isset($image_url) && $image_url != null) {
    $html .= "\"{$image_url}\" class=\"img-responsive img-rounded\" id=\"profileimg\">";
  } else {
    $html .= "\"../public/static/img/profile.png\" class=\"img-responsive img-rounded\">";
  }

  return $html;
}

// return relevant data from the user profile for the profile page
function get_user_profile_data($username) {
  global $connection;

  $safe_username = mysql_prep($username);

  $query = "SELECT username, full_name, year, employer, interests, bio, image_url ";
  $query .= "FROM user_profile ";
  $query .= "WHERE username = '{$safe_username}' ";

  $user_set = mysqli_query($connection, $query);
  confirm_query($user_set);

  if ($user = mysqli_fetch_assoc($user_set)) {
    return $user;
  }

  return null;
}

// submit profile data to database
function submit_profile($full_name, $year, $interests, $employer, $bio, $username) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_full_name = mysql_prep($full_name);
  $safe_year = mysql_prep($year);
  $safe_interests = mysql_prep($interests);
  $safe_employer = mysql_prep($employer);
  $safe_bio = mysql_prep($bio);

  $query = "UPDATE user_profile ";
  $query .= "SET full_name = '{$safe_full_name}', ";
  $query .= "year = '{$safe_year}', ";
  $query .= "interests = '{$safe_interests}', ";
  $query .= "employer = '{$safe_employer}', ";
  $query .= "bio = '{$safe_bio}', ";
  $query .= "last_updated_by = '{$safe_username}' ";
  $query .= "WHERE username = '{$safe_username}' ";

  if (mysqli_query($connection, $query)) {
    return "Success";
  } else {
    return "Failed - " . mysqli_error($connection);
  } 
}

// create an account in the database
function create_account($username, $password, $email_address, $name, $year, $employer, $bio, $interests) {
  global $connection;

  $safe_username = mysql_prep($username);
  $safe_name = mysql_prep($name);
  $safe_email_address = mysql_prep($email_address);
  $safe_year = mysql_prep($year);
  $safe_employer = mysql_prep($employer);
  $safe_bio = mysql_prep($bio);
  $safe_interests = mysql_prep($interests);
  $hashed_password = encrypt_password($password);
  
  $query = "CALL sp_createUserAccount('{$safe_username}', '{$hashed_password}', '{$safe_name}', ";
  $query .= "'{$safe_year}', '{$safe_employer}', '{$safe_bio}', '{$safe_interests}', '{$safe_email_address}') ";

  $result = mysqli_query($connection, $query) or die("Query fail: " . mysqli_error($connection));

  return $result;
}

// update the image url in the user_profile table
function update_url($file_path, $username) {
  global $connection;

  $safe_username = mysql_prep($username);

  $query = "UPDATE user_profile ";
  $query .= "SET image_url = '{$file_path}' ";
  $query .= "WHERE username = '{$safe_username}' ";

  if (mysqli_query($connection, $query)) {
    return "Success";
  } else {
    return "Failed - " . mysqli_error($connection);
  } 
}

// get the image_url
function get_image_url($username) {
  global $connection;

  $safe_username = mysql_prep($username);

  $query = "SELECT image_url ";
  $query .= "FROM user_profile ";
  $query .= "WHERE username = '{$safe_username}' ";

  $user_set = mysqli_query($connection, $query);
  confirm_query($user_set);

  if ($user = mysqli_fetch_assoc($user_set)) {
    $file_path = "../public/" . $user["image_url"];
    return $file_path;
  }

  return null;
}

// delete the current image
function delete_image($username) {
  $image_url = get_image_url($username);

  if ($image_url != null) {
    unlink($image_url); // deletes file
  }  
}

// gets html for displaying buttons on the profile page
function get_buttons_html() {
  $html = "<div class=\"col-sm-8\"><a class=\"btn btn-default pull-right profile-button\" id=\"show-profile-modal\" data-toggle=\"modal\">Edit Profile</a></div>";
  $html .= "<br>&nbsp<br>";
  $html .= "<div class=\"col-sm-8\"><a class=\"btn btn-default pull-right profile-button\" id=\"show-password-modal\" data-toggle=\"modal\">Change Password</a></div>";

  return $html;
}

// **************************************************
// LOGIN/PASSWORD FUNCTIONS
// **************************************************

// return a hashed password to store in the database
function encrypt_password($password) {
  $format = "$2y$10$"; // using Blowfish algorithm 10 times.
  $salt_length = 22; // need 22 characters for salt

  $salt = get_salt($salt_length);
  $format_and_salt = $format . $salt;
  $hashed_password = crypt($password, $format_and_salt);

  return $hashed_password;
}

// generate a random salt for encryption
function get_salt($length) {
  $random_string = md5(uniqid(mt_rand(), true));
  $base64 = base64_encode($random_string);
  $modified_base64 = str_replace("+", ".", $base64);

  $salt = substr($modified_base64, 0, $length);
  return $salt;
}

// Return true if password matches existing hash, false otherwise
function does_password_match($password, $existing_hash) {
  $hash = crypt($password, $existing_hash);

  if ($hash === $existing_hash) {
    return true;
  } else {
    return false;
  }
}

// returns data about the user if login succeeds, false otherwise.
function attempt_login($username, $password) {
  $user = find_user($username);
  if ($user) {
    // user found, check password
    if (does_password_match($password, $user["password"])) {
      // password matched, return user
      return $user;
    } else {
      // password does not match
      return false;
    }
  } else {
    // user not found
    return false;
  }
}

// returns true if the user is logged in and an admin, false otherwise
function is_user_admin() {
  if (is_logged_in()) {
    // return true if admin flag is set for this user
    return $_SESSION["admin_flag"] === "Y";
  } else {
    // user not logged in - can't be an admin
    return false;
  }
}

// returns true if the user is logged in and an owner, false otherwise
function is_user_owner() {
  if (is_logged_in()) {
    // return true if owner flag is set for this user
    return $_SESSION["owner_flag"] === "Y";
  } else {
    // user not logged in - can't be an owner
    return false;
  }
}

// returns true if user is logged in.
function is_logged_in() {
  return (isset($_SESSION["username"]));
}

// redirect user if not logged in
function confirm_login_status() {
  if (!is_logged_in()) {
    redirect_to("../public/index.php");
  }
}

// redirect the user if s/he is not an admin
function confirm_admin_status() {
  if (!is_user_admin() && !is_user_owner()) {
    redirect_to("../public/index.php");
  }
}

// logout user by removing pertinent session variables
function logout() {
  $_SESSION["username"] = null;
  $_SESSION["active_flag"] = null;
  $_SESSION["admin_flag"] = null;
  $_SESSION["owner_flag"] = null;
}

// update the user's password
function update_password($username, $password) {
  global $connection;

  $safe_username = mysql_prep($username);
  $hashed_password = encrypt_password($password);

  $query = "UPDATE user ";
  $query .= "SET password = '{$hashed_password}' ";
  $query .= "WHERE username = '{$safe_username}' ";

  if (mysqli_query($connection, $query)) {
    return "true";
  } else {
    return "Failed - " . mysqli_error($connection);
  } 
}

// **************************************************
// VALIDATION FUNCTIONS
// **************************************************

// returns true if the value is set and not an empty string
function has_presence($value) {
  return isset($value) && $value !== "";
}

// get the message from sessage and delete it afterwards
function get_session_message() {
  $message = "";
  if (isset($_SESSION["message"])) {
    $message = $_SESSION["message"];
    $_SESSION["message"] = null;
  }
  return $message;
}

// **************************************************
// EMAIL FUNCTIONS
// **************************************************

// get the email address to use for the given type email
function get_email_address($email_type) {
  global $connection;

  $safe_email_type = mysql_prep($email_type);

  $query = "SELECT email_address ";
  $query .= "FROM admin_email_addresses ";
  $query .= "WHERE email_type = '{$safe_email_type}' ";
  $query .= "LIMIT 1 ";

  $email_set = mysqli_query($connection, $query);
  confirm_query($email_set);

  if ($address = mysqli_fetch_assoc($email_set)) {
    return $address["email_address"];
  } else {
    return null;
  }
}

// build a message to send for the question report email
function get_report_email_text($username, $question_id, $report_text) {
  global $connection;

  $query = "SELECT c.category_name, q.question_text, qz.quiz_name ";
  $query .= "FROM question q ";
  $query .= "JOIN quiz qz ON qz.quiz_id = q.quiz_id ";
  $query .= "JOIN category c on c.category_id = qz.category_id ";
  $query .= "WHERE q.question_id = {$question_id} ";

  $question_set = mysqli_query($connection, $query);
  confirm_query($question_set);

  if ($question = mysqli_fetch_assoc($question_set)) {
    $message = "Category: " . $question["category_name"] . "<br>";
    $message .= "Quiz: " . $question["quiz_name"] . "<br>";
    $message .= "Question ID: " . $question_id . "<br>";
    $message .= "Question Text: " . $question["question_text"] . "<br>";
    $message .= "Report Text: " . $report_text;

    return $message;
  } else {
    return null;
  }
}

// send an email
function send_email($email_type, $subject, $message) {
  $email_address = get_email_address($email_type);

  if ($email_address == null) {
    return null;
  }

  // headers for the email
  $headers =  'MIME-Version: 1.0' . "\r\n"; 
  $headers .= 'From: PharmGenius <DO NOT REPLY>' . "\r\n";
  $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";

  mail($email_address, $subject, $message, $headers);
}

// **************************************************
// LEADERBOARD FUNCTIONS
// **************************************************

//This function takes the quiz name and category in order to find the quiz_id needed for the main query
function get_quiz_id($quiz, $category){
  global $connection;
  $query = "SELECT q.quiz_id FROM quiz as q JOIN category as c ";
  $query .= "WHERE q.category_id = c.category_id AND c.category_name = '$category' AND q.quiz_name = '$quiz'";
  $result = $connection->query($query);
  $quiz_id = $result;
  if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()){
      $quiz_id = $row["quiz_id"];
    }
  }
  return $quiz_id;
}


# This function queries to the database and returns all the users that should appear in the database
# specified by the user
function get_leaderboard_view($timePeriod, $category, $subcategory){
  global $connection;
  $days = 0;
  $quiz_id = 0;
  if($subcategory !== "ALL"){
    $quiz_id = get_quiz_id($subcategory, $category);
  }
  # These statements determine how long ago we are looking for in the database
  if($timePeriod == "Past Month"){
    $days = 31;
  } else if($timePeriod == "Past Week"){
    $days = 7;
  } else if($timePeriod == "Past Year"){
    $days = 365;
  }
  $current_date = date("Y-m-d H:i:s");
  $query = "SELECT quiz_id, question_id, username, score ";
  $query .= "FROM vw_correctanswers_v3 ";
  $and = false;
  
  //This chunk of if statements will add to the query if needed
  if($timePeriod == "ALL" and $subcategory == "ALL" and $category == "ALL"){
    $no_where = true;
  } else {
    $query .= "WHERE ";
    if($timePeriod !== "ALL"){
      $query .= "DATEDIFF('$current_date', created_date) <= $days ";
      $and = true;
    }
    if($subcategory !== "ALL"){
      if($and){
        $and = false;
        $query .= "and ";
      }
      $query .= " quiz_id = $quiz_id ";
      $and = true;
    }
    if($category !== "ALL"){
      if($and){
        $and = false;
        $query .= "and ";
      }
      $query .= "category_name = '$category' ";
    }
  }
  
  if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
  }
  $result = $connection->query($query);
  $sorted_score = [];  // Saves the scores sorted in order
  $user_array = []; // Associative array that holds the users with their scores
  $previous_user = "";
  $total = 0;
  $index = 0;
  $not_first = false;
  if ($result->num_rows > 0) {
    // calculate score
    // Since we want to find out the score, we go through every correct answer the user had and calculate the score.
    // When the user answered the same question multiple times, we take the total amount of times it was answered (count)
    // And use .9^count to calculate the score from that one question. (so the 1st answer is 100, then 90 for the 2nd, etc.)
    // once I go through all the tuples of correctly answered questions for that user, I save the score and user into
    // the arrays.
    while($row = $result->fetch_assoc()){
      $score = $row["score"];
      $user = $row["username"];
      if(!$not_first){
        $previous_user = $user;
        $not_first = true;
      }
      if($user != $previous_user){
        $tied_score = check_score($sorted_score, $total);
        if($tied_score){
          array_push($user_array[$total], $previous_user);
          $previous_user = $user;
          $total = 0;
        } else {
          $user_array[$total] = [$previous_user];
          $sorted_score[$index] = $total;
          $previous_user = $user;
          $total = 0;
          $index++;
        }
      }
      $total += $score;
    }
    $tied_score = check_score($sorted_score, $total);
    if($tied_score){
      array_push($user_array[$total], $previous_user);
    } else {
      $user_array[$total] = [$previous_user];
      $sorted_score[$index] = $total;
    }
    sort($sorted_score);
  }
  $return_array = [];
  array_push($return_array, $sorted_score, $user_array);

  return $return_array;
}
//This function checks to see if someone else has the same score
function check_score($check_score, $new_score){
  for($x = 0; $x < sizeof($check_score); $x++){
    if($check_score[$x] == $new_score){
      return true;
    }
  }
  return false;
}

// Returns the categories from the database
function get_categories(){
  global $connection;
  $query = "SELECT category_name ";
  $query .= "FROM category ";
  
  if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
  }
  $result = $connection->query($query);
  $category_array = null;
  if ($result->num_rows > 0) {
    $index = 0;
    while($row = $result->fetch_assoc()){
      $category = $row["category_name"];
      $category_array[$index] = $category;
      $index++;
    }
  }
  return $category_array;
}

// Returns the subCategories that correspond with the selected category
function get_subcategories($category){
  global $connection;
  $query = "SELECT q.quiz_name FROM `quiz` as q JOIN `category` as c ";
  $query .= "WHERE q.category_id = c.category_id AND c.category_name = '$category'";
  if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
  }
  $result = $connection->query($query);
  $subcategory_array = null;
  if ($result->num_rows > 0) {
    $index = 0;
    while($row = $result->fetch_assoc()){
      $subcategory = $row["quiz_name"];
      $subcategory_array[$index] = $subcategory;
      $index++;
    }
  }
  return $subcategory_array;
}

?>