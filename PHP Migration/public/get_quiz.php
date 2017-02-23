<?php session_start(); ?>
<?php require_once("../includes/db_connection.php") ?>
<?php require_once("../includes/functions.php"); ?>

<?php confirm_login_status(); ?>

<?php
  // we want to form JSON for the quiz, so we'll be building an array
  // The quiz array will store some basic info about the quiz and an array of questions
  // The questions array will store basic info about the question and an array of answers
  // The array of answers will store base info about the answers, etc.

  if (!isset($_POST["quiz"])) {
    redirect_to("select_quiz.php"); // something went wrong or was a GET request - redirect
  }

  $the_quiz = get_quiz($_POST["quiz"]);             // stores the quiz data that will be JSON Encoded and returned
  $the_quiz["time_per_question"] = $_POST["timed"]; // store the time per question

  $num_questions = isset($_POST["number"]) ? $_POST["number"] : 5;  // default to 5 questions if something goes wonky
  $username = isset($_POST["mine"]) ? $_SESSION["username"] : null; // need to give username to the get questions query if set

  // we pass in the following variables: the quiz_id, the number of questions desired, true of false for whether
  // or not the quiz taker only wishes to view their questions, and true to make sure that only active questions come back
  $the_quiz["questions"] = get_questions_for_quiz($the_quiz["quiz_id"], $num_questions, $username, true);

  // get all the answers for the questions
  if (sizeof($the_quiz["questions"]) > 0) {    
    for ($i = 0; $i < sizeof($the_quiz["questions"]); $i++) {
      // set the answers array of this question to the answers for the question.
      // this is a bit verbose, but there's really no need to break this down into separate variables
      // we're just drilling down into the arrays
      $the_quiz["questions"][$i]["answers"] = get_answers_for_question($the_quiz["questions"][$i]["question_id"]);
    }
  }

  // tell php this is JSON data
  header("Content-Type: application/json");

  // our quiz is built - echo the JSON for retrieval from take_quiz.php
  echo json_encode($the_quiz);

?>