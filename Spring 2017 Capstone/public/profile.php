<?php session_start(); ?>
<?php require_once("../includes/db_connection.php") ?>
<?php require_once("../includes/functions.php"); ?>
<?php confirm_login_status(); ?>
<?php 
  if (isset($_GET["id"]) && isset($_SESSION["username"])) {
    $profile_data = get_user_profile_data($_SESSION["username"]);
  } else {
    redirect_to("../public/index.php");
  }
?>
<?php include("../includes/header.php"); ?>

<script src="static/js/jquery.easing.min.js"></script>

</head>
<body>
<?php echo get_navbar(); ?>

  <div class= "container col-lg-12s">
    <br><br><br><br>
    <div class="text-left text-center-div">
      <h2 id="usernameheader"><?php echo $profile_data["username"]; ?>'s Profile Information:</h2>
    </div>
    <hr>
    <div class="col-sm-4">
      <?php echo get_profile_image_html($profile_data["image_url"]); ?>
      <br>
    </div>
    <div class="col-sm-8">
      <label class="control-label">Name:</label>&nbsp<label class="profileDisplay" id="displayName"><?php echo $profile_data["full_name"]; ?></label><br>
      <label class="control-label">Year:</label>&nbsp<label class="profileDisplay" id="displayYear"><?php echo $profile_data["year"]; ?></label><br>
      <label class="control-label">Interests:</label>&nbsp<label class="profileDisplay" id="displayInterests"><?php echo $profile_data["interests"]; ?></label><br>
      <label class="control-label">Employer:</label>&nbsp<label class="profileDisplay" id="displayEmployer"><?php echo $profile_data["employer"]; ?></label><br>
      <label class="control-label">Bio:</label>&nbsp<label class="profileDisplay" id="displayBio"><?php echo $profile_data["bio"]; ?></label><br>
      <br><br><br>
    </div>
    <?php 
      // only display buttons if this profile page is for the currently logged on user
      if ($profile_data["username"] == $_SESSION["username"]) {
        echo  get_buttons_html();
      }
    ?>
    <br><br>
  </div>

  <div class="modal fade" id="editprofile" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <he5>Edit Profile Information</he5>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label for: "name" class="col-lg-2 control-label">Name: *</label>
            <div class="col-lg-10">
              <input type="text" class="form-control" name="name" id="name" value=<?php echo "\"" . $profile_data["full_name"] . "\""; ?> maxlength=50>
            </div>
          </div>
          <br><br>
          <div class="form-group">
            <label for: "Location" class="col-lg-2 control-label">Year: *</label>
            <div class="col-lg-10">
              <input type="text" class="form-control" name="year" id="year" value=<?php echo "\"" . $profile_data["year"] . "\""; ?> maxlength=10>
            </div>
          </div>
          <br><br>
          <div class="form-group">
            <label for: "img" class="col-lg-2 control-label">Image: </label>
            <div class="col-lg-10">
              <input type="file" class="form-control upload-file" name="profileimage" id="profileimage">
            </div>
          </div>
          <br><br>
          <div class="form-group">
            <label for: "Interests" class="col-lg-2 control-label">Interests: </label>
            <div class="col-lg-10">
              <textarea type="text" class="form-control" name="interests" id="interests" value="" maxlength=256><?php echo $profile_data["interests"]; ?></textarea>
            </div>
          </div>
          <br><br><br>
          <div class="form-group">
            <label for: "Employer" class="col-lg-2 control-label">Employer: </label>
            <div class="col-lg-10">
              <input type="text" class="form-control" name="employer" id="employer" value=<?php echo "\"" . $profile_data["employer"] . "\""; ?> maxlength=50>
            </div>
          </div>
          <br><br>
          <div class="form-group">
            <label for: "Bio" class="col-lg-2 control-label">Bio:</label>
            <div class="col-lg-10">
              <textarea type="text" class="form-control" name="bio" id="bio" value="" maxlength=500><?php echo $profile_data["bio"]; ?></textarea>
            </div>
          </div>
          <br><br>
        </div>
        <div class="modal-footer">
          <a class="btn btn-default text-right" data-dismiss="modal">Close</a>
          <button type="submit" id="submit-profile" class="btn btn-primary">Submit</button>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" id="changepassword" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <he5>Change Password</he5>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label for: "password" class="col-lg-4 control-label">Current: *</label>
            <div class="col-lg-8">
              <input type="password" class="form-control" name="oldpassword" id="oldpassword" value="" maxlength=20>
            </div>
          </div>
          <br><br>
          <div class="form-group">
            <label for: "newpassword" class="col-lg-4 control-label">New: *</label>
            <div class="col-lg-8">
              <input type="password" class="form-control" name="newpassword" id="newpassword" value="" maxlength=20>
            </div>
          </div>
          <br><br>
          <div class="form-group">
            <label for: "retypepassword" class="col-lg-4 control-label">Retype: *</label>
            <div class="col-lg-8">
              <input type="password" class="form-control" name="retypepassword" id="retypepassword" value="" maxlength=20>
            </div>
          </div>
          <br><br>
        </div>
        <div class="modal-footer">
          <a class="btn btn-default text-right" data-dismiss="modal">Close</a>
          <button type="submit" id="submit-password" class="btn btn-primary">Submit</button>
        </div>
      </div>
    </div>
  </div>

<script src="../public/static/js/profile.js"></script>

<?php include("../includes/footer.php"); ?>