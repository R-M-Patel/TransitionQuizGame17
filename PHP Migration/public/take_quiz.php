<?php session_start(); ?>
<?php require_once("../includes/db_connection.php") ?>
<?php require_once("../includes/functions.php"); ?>

<?php confirm_login_status(); ?>

This is take_quiz.php

<pre>
<?php
	var_dump($_POST);

	$question_array = array();

	$question_set = get_questions_for_quiz($_POST["quiz"], true);
	while($question = mysqli_fetch_assoc($question_set)) {
		$this_question = array();
		$this_question["question_text"] = $question["question_text"];
		$this_question["question_id"] = $question["question_id"];
		$answer_set = get_answers_for_question($question["question_id"]);
		$answer_num = 0;
		while($answer = mysqli_fetch_assoc($answer_set)) {
			$this_question["answer_".$answer_num] = $answer["answer_text"];
			$this_question["answer_".$answer_num."_id"] = $answer["answer_id"];
			$this_question["answer_".$answer_num."_chosen"] = $answer["times_chosen"];
			if ($answer["correct_flag"] === "Y") {
				$this_question["correct_answer"] = $answer["answer_id"];
			}
			$answer_num++;
		}
		$question_array[] = $this_question;
	}

	var_dump($question_array);

?>
</pre>