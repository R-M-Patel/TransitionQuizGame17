<?php 
	session_start();
	require_once("db_connection.php");
	require_once("functions.php"); 

	// make sure someone who isn't logged in is not trying to access this page
	confirm_login_status();

	// make sure category was sent
	if (!isset($_GET["category"])) {
		redirect_to("../public/index.php");
	}

	// category ID is in the URL
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