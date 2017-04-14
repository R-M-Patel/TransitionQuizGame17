<?php session_start(); ?>
<?php require_once("../includes/db_connection.php"); ?>
<?php require_once("../includes/functions.php"); ?>
<?php confirm_login_status(); ?>
<?php include("../includes/header.php"); ?>

<script src="static/js/jquery.easing.min.js"></script>
</head>
<body>
<?php echo get_navbar(); ?>
<br/><br/><br/><br/>
<div class="container">
  <div class="container col-xs-12 text-center-div">
    <h2 class="inline-element">Leaderboard</h2>
  </div>
  <div class = "container col-xs-12"><hr></div>
  <div class= "container col-md-6">
    Category: &nbsp
    <select class="selectpicker cat" id="category" name="category" method="POST">
      <option selected value="ALL">All</option>
    </select><br/><br/>
  </div>
  <div class= "container col-md-6">
    Subcategory: &nbsp
    <select class="selectpicker cat" id="subCategory" name="subCategory" method="POST">
      <option selected value="ALL">All</option>
    </select><br/><br/>
  </div>
  <div class = "container col-md-6">
    Time: &nbsp
    <select class="selectpicker cat" id="timePeriod" name="timePeriod" method="POST">
      <option selected value="ALL">All Time</option>
      <option value="Past Week">Past Week</option>
      <option value="Past Month">Past Month</option>
      <option value="Past Year">Past Year</option>
    </select><br/><br/>
  </div>
  <div class = "container col-xs-12"><br></div>
  <div class="container col-xs-12">
    <table id="leaderboard" class='leaderboard'>
      <thead>
      <th width='5%' class='pad'>Rank</th>
      <th class='pad'>Name</th>
      <th class='pad'>Points</th>
      </thead>
      <tbody>
      </tbody>
    </table>
  </div>
</div>
<br>

<script src="../public/static/js/leaderboard.js"></script>

<?php include("../includes/footer.php"); ?>