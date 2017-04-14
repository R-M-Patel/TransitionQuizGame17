<?php session_start(); ?>
<?php require_once("../includes/db_connection.php"); ?>
<?php require_once("../includes/functions.php"); ?>
<?php include("../includes/header.php"); ?>
</head>

<body id="page-top" class="main-page-body" data-spy="scroll" data-target=".navbar-fixed-top">
  <homebody>

  <?php echo get_navbar(); ?>

  <header id="top" class="intro">
    <div class="intro-body">
      <div id="description" class="col-md-8 col-md-offset-2">
        <h1 class="brand-heading">PharmGenius</h1>
        <p class="intro-text">An easy, fun way to help pharmacy
        students learn and study.<br>Get started now!</p>

        <?php echo get_play_button_display(); ?>

      </div>           
    </div>
  </header>
  </homebody>

<?php include("../includes/footer.php"); ?>