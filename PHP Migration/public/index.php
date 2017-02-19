<?php session_start(); ?>
<?php require_once("../includes/db_connection.php"); ?>
<?php require_once("../includes/functions.php"); ?>

<?php 
	$user = attempt_login("mjb236", "default"); 
	if ($user) {
		$_SESSION["username"] = $user["username"];
		$_SESSION["active_flag"] = $user["active_flag"];
		$_SESSION["admin_flag"] = $user["admin_flag"];
		$_SESSION["owner_flag"] = $user["owner_flag"];
	}
?>

<?php include("../includes/header.php"); ?>
</head>

<body id="page-top" data-spy="scroll" data-target=".navbar-fixed-top">
  <homebody>
    <!-- <homebody> -->
    <!-- Navigation -->
    <?php echo get_navbar(); ?>
    <!-- Intro Header -->
    <header id="top" class="intro">
        <div class="intro-body">
            <div style="position:relative" id="description" class="col-md-8 col-md-offset-2">
                <h1 class="brand-heading">PharmGenius</h1>
                <p class="intro-text">An easy, fun way to help pharmacy
                students learn and study.<br>Get started now!</p>

                <?php echo get_play_button_display(); ?>

            </div>           
        </div>
    </header>
  </homebody>

<?php include("../includes/footer.php"); ?>