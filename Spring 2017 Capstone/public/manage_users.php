<?php session_start(); ?>
<?php require_once("../includes/db_connection.php"); ?>
<?php require_once("../includes/functions.php"); ?>
<?php confirm_admin_status(); ?>
<?php
  $user_set = get_user_data();
  include("../includes/header.php");
?>
<script src="static/js/jquery.easing.min.js"></script>
<script src="../public/static/js/manage_users.js"></script>
</head>
<body>
  <?php echo get_navbar(); ?>
  <br><br><br><br>  
  <div class="container">
    <div class="container col-xs-12 text-center-div">
      <h2 class="inline-element">Manage Users</h2>
    </div>
    <div class="container col-xs-12"><hr></div>
    <div class="container col-xs-12"><br></div>
    <div class="container col-xs-12">
      <table id="usertable" class="usertable">
        <thead>
        <th>Username</th>
        <th>Score</th>
        <th>Full Name</th>
        <th>Year</th>
        <th>Member Since</th>
        <th>Active</th>
        <th>Admin</th>
        <th>Owner</th>
        <th>Reset Score</th>
        </thead>
        <tbody>
          <!-- For every user that was found, we insert a table row with data and buttons to adjust active/admin status -->
          <!-- there is also a button to allow an admin to reset a user's score -->
          <?php
            while ($user = mysqli_fetch_assoc($user_set)) {
              $table_row = "<tr><td>" . $user["username"] . "</td>";
              $table_row .= "<td id=\"score_{$user["username"]}\">" . $user["score"] . "</td>";
              $table_row .= "<td>" . $user["full_name"] . "</td>";
              $table_row .= "<td>" . $user["year"] . "</td>";
              $table_row .= "<td>" . $user["registered_date"] . "</td>";
              $table_row .= "<td>";
              $table_row .= "<button type=\"button\" id=\"active_flag_{$user["username"]}\" onclick=\"toggleStatus('active_flag', '{$user["username"]}')\">";
              $table_row .= ($user["active_flag"] == "Y") ? "Yes - Demote" : "No - Promote";
              $table_row .= "</td>";
              $table_row .= "<td>";
              $table_row .= "<button type=\"button\" id=\"admin_flag_{$user["username"]}\" onclick=\"toggleStatus('admin_flag', '{$user["username"]}')\">";
              $table_row .= ($user["admin_flag"] == "Y") ? "Yes - Demote" : "No - Promote";
              $table_row .= "</td>";
              $table_row .= "<td>" . $user["owner_flag"] . "</td>";
              $table_row .= "<td>";
              $table_row .= "<button type=\"button\" onclick=\"resetScore('{$user["username"]}')\">";
              $table_row .= "Reset Score";
              $table_row .= "</td>";
              $table_row .= "</tr>";

              echo $table_row;
            }
          ?>
        </tbody>
      </table>
    </div>
  </div>

<?php include("../includes/footer.php"); ?>