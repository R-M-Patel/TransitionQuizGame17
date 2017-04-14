<?php session_start(); ?>
<?php require_once("../includes/db_connection.php"); ?>
<?php require_once("../includes/functions.php"); ?>
<?php confirm_admin_status(); ?>
<?php include("../includes/header.php"); ?>

<script src="static/js/jquery.easing.min.js"></script>

</head>
<body>
  <?php echo get_navbar(); ?>
  <br><br><br><br>
  <div class="container">
    <div class="container col-lg-12 text-center-div">
      <h2 class="inline-element">Categories</h2>
      <hr>
    </div>
    <div class="container col-lg-12"><br></div>
    <div class="container col-lg-4"></div>
    <div class="container col-lg-4">
      In rotation:
      <table id="acceptedBoard">
        <thead>
          <th width='20%'>Remove</th>
          <th>Category</th>
        </thead>
        <tbody>
        </tbody>
      </table>
      <hr>
      Out of rotation:
      <table id="newBoard">
        <thead>
          <th width='20%'>Add</th>
          <th width='20%'>Delete</th>
          <th>Category</th>
        </thead>
        <tbody>
        </tbody>
      </table>
    </div>
    <div class="container col-lg-4"></div>
    <br>
  </div>
  <br>

<script src="../public/static/js/review_categories.js"></script>
<?php include("../includes/footer.php"); ?>