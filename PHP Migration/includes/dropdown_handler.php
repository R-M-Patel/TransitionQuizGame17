<?php 
	require_once("../includes/db_connection.php");
	require_once("../includes/functions.php"); 

	$category_id = $_GET["category"];

	$quiz_set = get_quizzes_for_category($category_id, true);

	while ($quiz = mysqli_fetch_assoc($quiz_set)) {
		$name = $quiz["quiz_name"];
	    $id = $quiz["quiz_id"];
	    echo "<option value=\"{$id}\">{$name}</option>";
	}

	// close connection
    if (isset($connection)) {
      mysqli_close($connection);
  	}
?>