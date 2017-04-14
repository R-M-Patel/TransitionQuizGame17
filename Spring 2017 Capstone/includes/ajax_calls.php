<?php session_start(); ?>
<?php require_once("db_connection.php") ?>
<?php require_once("functions.php"); ?>
<?php 
  // don't need to be logged in to check username
  if (isset($_GET["get_action"]) && $_GET["get_action"] == "check_username_availability") {
    return check_username_availability_in_database();
  }
  // don't need to be logged in to check email
  if (isset($_GET["get_action"]) && $_GET["get_action"] == "check_email_availability") {
    return check_email_availability_in_database();
  }
  // don't need to be logged in to create account
  if (isset($_POST["action"]) && $_POST["action"] == "create_account") {
    return create_account_in_database();
  } else if (isset($_POST["action"]) && $_POST["action"] == "upload_image") {
    return upload_image_to_site();
  }
?> 
<?php confirm_login_status(); ?>
<?php

  // handle get requests here, make sure to return so that the POST section below does not run.
  // the get_quiz section should also probably be a get request instead of a post, but I am
  // reluctant to change it because it is working.
  if (isset($_GET["get_action"])) {
    switch ($_GET["get_action"]) {
      case "get_categories": return get_categories_from_database(); break;
      case "check_category_availability": return check_category_availability_in_database(); break;
    }
  }

  if (isset($_POST["action"])) {
    switch ($_POST["action"]) {
      case "get_quiz": get_quiz_from_database(); break;
      case "submit_answer": submit_answer_to_database(); break;
      case "submit_vote": submit_vote_to_database(); break;
      case "submit_report": submit_report_to_database(); break;
      case "toggle_user_flag": toggle_user_flag(); break;
      case "submit_bug": submit_bug_to_database(); break;
      case "update_times_chosen": update_times_answer_chosen(); break;
      case "submit_profile": submit_profile_to_database(); break;
      case "update_password": echo update_password_in_database(); break; // echo here so we can verify it worked in the javascript
      case "update_category_active_status": update_category_active_status(); break;
      case "reset_user_score": reset_user_score_in_database(); break;
      case "create_category": create_category_in_database(); break;  
      case "create_question": create_question_in_database(); break;
      case "create_quiz": create_quiz_in_database(); break;
    }
  }

  // get a json verson of the quiz and return to the site
  function get_quiz_from_database() {
    // we want to form JSON for the quiz, so we'll be building an array
    // The quiz array will store some basic info about the quiz and an array of questions
    // Each item in the questions array will store basic info about the question and an array of answers
    // Each item in the  array of answers will store basic info about the answers, etc.

    if (!isset($_POST["quiz"])) {
      redirect_to("select_quiz.php"); // something went wrong or was a GET request - redirect
    }

    $the_quiz = get_quiz($_POST["quiz"]);             // stores the quiz data that will be JSON Encoded and returned
    $the_quiz["time_per_question"] = $_POST["timed"]; // store the time per question

    $num_questions = isset($_POST["number"]) ? $_POST["number"] : 5;  // default to 5 questions if something goes wonky
    $username = isset($_POST["mine"]) ? $_SESSION["username"] : null; // need to give username to the get questions query if set

    // we pass in the following variables: the quiz_id, the number of questions desired, the user name if
    // the quiz taker only wishes to view their questions (null otherwise), 
    // and true to make sure that only active questions come back
    $the_quiz["questions"] = get_questions_for_quiz($the_quiz["quiz_id"], $num_questions, $username, true);

    // get all the answers for the questions
    if (sizeof($the_quiz["questions"]) > 0) {    
      for ($i = 0; $i < sizeof($the_quiz["questions"]); $i++) {
        // set the answers array of this question to the answers for the question.
        // this is a bit verbose, but there's really no need to break this down into separate variables
        // we're just drilling down into the arrays
        $the_quiz["questions"][$i]["answers"] = get_answers_for_question($the_quiz["questions"][$i]["question_id"]);

        // we also need to get votes for each question, and the user's vote for this question
        $the_quiz["questions"][$i]["total_vote_value"] = get_vote_value_for_question($the_quiz["questions"][$i]["question_id"]);
        $the_quiz["questions"][$i]["user_vote"] = get_vote_value_for_user($_SESSION["username"], $the_quiz["questions"][$i]["question_id"]);

        // we also want how many times this user has answered this question correctly for score calculations
        $the_quiz["questions"][$i]["user_correct_answers"] = get_correct_answer_count($_SESSION["username"], $the_quiz["questions"][$i]["question_id"]);

        // determine whether or not this question was already reported by the user
        $the_quiz["questions"][$i]["is_reported"] = is_question_reported_by_user($_SESSION["username"], $the_quiz["questions"][$i]["question_id"]);
      }
    }

    // tell php this is JSON data
    header("Content-Type: application/json");

    // our quiz is built - echo the JSON for retrieval from take_quiz.php
    echo json_encode($the_quiz);
  }

  // submit an answer to the database
  function submit_answer_to_database() {
    if (isset($_POST["question_id"]) && isset($_POST["correct_flag"]) && isset($_POST["score"]) && isset($_POST["answer_id"])) {
      submit_answer($_POST["question_id"], $_POST["correct_flag"], $_SESSION["username"], $_POST["score"], $_POST["answer_id"]);
    }
  }

  // increment the number of times this answer was chosen
  function update_times_answer_chosen() {
    if (isset($_POST["answer_id"])) {
      update_times_chosen($_POST["answer_id"]);
    }
  }

  // submit a vote on a question to the database
  function submit_vote_to_database() {
    if (isset($_POST["question_id"]) && isset($_POST["value"])) {
      submit_vote($_SESSION["username"], $_POST["question_id"], $_POST["value"]);
    }
  }

  // submit a question report to the database
  function submit_report_to_database() {
    if (isset($_POST["question_id"]) && isset($_POST["problem_text"])) {
      submit_report($_SESSION["username"], $_POST["question_id"], $_POST["problem_text"]);
    }
  }

  // set the specified flag to the new flag value
  function toggle_user_flag() {
    if (isset($_POST["flag_name"]) && isset($_POST["new_flag_value"]) && isset($_POST["username"])) {
      toggle_user_flag_status($_POST["flag_name"], $_POST["new_flag_value"], $_POST["username"]);
    }
  }

  // submit a bug report to the database
  function submit_bug_to_database() {
    if (isset($_POST["report_text"])) {
      submit_bug($_POST["report_text"], $_SESSION["username"]);
    }
  }

  // submit profile data to database
  function submit_profile_to_database() {
    if (isset($_POST["full_name"]) && isset($_POST["year"]) && isset($_SESSION["username"])) {
      submit_profile($_POST["full_name"], $_POST["year"], $_POST["interests"], $_POST["employer"], $_POST["bio"], $_SESSION["username"]);
    }
  }

  // change a password in the database
  function update_password_in_database() {
    if (isset($_POST["old_password"]) && isset($_POST["old_password"]) && isset($_SESSION["username"])) {
      $user = attempt_login($_SESSION["username"], $_POST["old_password"]);
      if ($user == false) {
        return "false";
      } else {
        return update_password($_SESSION["username"], $_POST["new_password"]);
      }
    }
  }

  // get all categories from the database
  function get_categories_from_database() {
    $category_set = get_all_categories(false); // get all categories, not just active
    $categories = array();
    while ($category = mysqli_fetch_assoc($category_set)) {
      $categories[] = $category;
    }
    echo json_encode($categories);    
  }

  // update the active flag on a given catgory
  function update_category_active_status() {
    if (isset($_POST["category_id"]) && isset($_POST["active_flag"])) {
      update_category_active_flag($_POST["category_id"], $_POST["active_flag"]);
    }
  }

  // resets the user's score in the database
  function reset_user_score_in_database() {
    if (isset($_POST["username"])) {
      reset_user_score($_POST["username"]);
    }
  }

  // check if the username is available
  function check_username_availability_in_database() {
    $result = array();
    if (isset($_GET["username"])) {
      if (check_username_availability($_GET["username"]) == "true") {
        $result["exists"] = "true";
      } else {
        $result["exists"] = "false";
      }

      echo json_encode($result);
    }
  }

  // check if the email is available
  function check_email_availability_in_database() {
    $result = array();
    if (isset($_GET["email"])) {
      if (check_email_availability($_GET["email"]) == "true") {
        $result["exists"] = "true";
      } else {
        $result["exists"] = "false";
      }

      echo json_encode($result);
    }
  }

  // check if the category already exists by name
  function check_category_availability_in_database() {
    $result = array();
    if (isset($_GET["category_text"])) {
      if (check_category_availability($_GET["category_text"]) == "true") {
        $result["exists"] = "true";
      } else {
        $result["exists"] = "false";
      }

      echo json_encode($result);
    }
  }

  // create a user account
  function create_account_in_database() {
    if (isset($_POST["username"]) && isset($_POST["password"]) && isset($_POST["name"]) && isset($_POST["year"]) && isset($_POST["email_address"])) {
      create_account($_POST["username"], $_POST["password"], $_POST["email_address"], $_POST["name"], $_POST["year"], $_POST["employer"], $_POST["bio"], $_POST["interests"]);
    }
  }

  // upload an image to the database and set the user's image location to where it is stored
  function upload_image_to_site() {
    if (isset($_FILES["profileimage"]["name"]) && isset($_POST["username"])) {
      // delete the current file if present
      delete_image($_POST["username"]);

      $file_path = "static/img/" . $_POST["username"] . "_" . $_FILES["profileimage"]["name"];
      move_uploaded_file($_FILES["profileimage"]["tmp_name"], $file_path);
      update_url($file_path, $_POST["username"]);
      echo $file_path;
    } 
  }

  // creates a category and a quiz in the database
  function create_category_in_database() {
    if (isset($_SESSION["username"]) && isset($_POST["category_name"]) && isset($_POST["quiz_name"])) {
      create_category($_SESSION["username"], $_POST["category_name"], $_POST["quiz_name"]);
    }
  }

  // create a question
  function create_question_in_database() {
    if (isset($_SESSION["username"]) && isset($_POST["question_text"]) && isset($_POST["quiz_id"]) && isset($_POST["correct_answer"])
        && isset($_POST["answer1"]) && isset($_POST["answer2"]) && isset($_POST["answer3"]) && isset($_POST["answer4"])) {
      create_question($_SESSION["username"], $_POST["question_text"], $_POST["quiz_id"], $_POST["explanation"], $_POST["correct_answer"],
        $_POST["answer1"], $_POST["answer2"], $_POST["answer3"], $_POST["answer4"]);
    }
  }

  // create a quiz
  function create_quiz_in_database() {
    if (isset($_SESSION["username"]) && isset($_POST["quiz_name"]) && isset($_POST["category_id"])) {
      create_quiz($_SESSION["username"], $_POST["quiz_name"], $_POST["category_id"]);
    }
  }

	// close connection
  if (isset($connection)) {
    mysqli_close($connection);
  }
?>