<?php session_start(); ?>
<?php require_once("../includes/functions.php"); ?>
<?php logout(); ?>
<?php redirect_to("index.php"); ?>