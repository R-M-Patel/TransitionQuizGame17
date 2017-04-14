<?php session_start(); ?>
<?php require_once("db_connection.php") ?>
<?php require_once("functions.php"); ?>
<?php confirm_login_status(); ?>
<?php

  if($_POST["action"] == "scores"){
    $scores = get_leaderboard_view($_POST["timePeriod"], $_POST["category"], $_POST["subCategory"]);
    echo json_encode($scores);
  } else if($_POST["action"] == "categories"){
    $categories = get_categories();
    echo json_encode($categories);
  } else if($_POST["action"] == "subcategories"){
    $subcat = get_subcategories($_POST["category"]);
    echo json_encode($subcat);
  }  
?>