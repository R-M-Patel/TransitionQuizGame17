<?php session_start(); ?>
<?php require_once("../includes/db_connection.php"); ?>
<?php require_once("../includes/functions.php"); ?>
<?php include("../includes/header.php"); ?>

</head>
<body>
  <?php echo get_navbar(); ?>
  <br><br><br><br>
  <div class="container">
    <h3 class="inline-element">Create Profile</h3><br>
    <span>You must create a profile before continuing!</span>
    <hr>
      <div class="container form-error" id='doesNotExist'><i class="fa fa-exclamation-circle"> Username Taken</i></div>
      <div class="container form-error" id='invalid'><i class="fa fa-exclamation-circle"> Invalid Username (3-20 characters, uppercase, lowercase, numbers, and underscores)</i></div>
      <div class="container form-valid" id='exists'><i class="fa fa-exclamation-circle"> Username Available</i></div>
      <div class="container form-error" id='emailtaken'><i class="fa fa-exclamation-circle"> Email Taken</i></div>
      <div class="container col-lg-6 account-form-div">
        <span>User Name: *</span><br>
        <input type="text" class="form-control" name="username" id="username" pattern=".{3,15}" title="3-20 characters,uppercase,lowercase,numbers,underscores" maxlength=20 required></input>
      </div>
      <div class="container col-lg-6">
        <span>Password: *</span><br>
        <input type="password" class="form-control" name="password" id="createpassword" pattern=".{3,20}" title="3-20 characters,uppercase,lowercase,numbers,underscores" maxlength=20 required></input>
      </div>
      <div class="container col-lg-6">
        <span>Retype Password: *</span><br>
        <input type="password" class="form-control" name="retypepassword" id="createpasswordretype" pattern=".{3,20}" title="3-20 characters,uppercase,lowercase,numbers,underscores" maxlength=20 required></input>
      </div>
      <div class="container col-lg-6">
        <span>Name: *</span><br>
        <input type="text" class="form-control" name="name" id="name" maxlength=70 required>
      </div>
      <div class="container col-lg-6">
        <span>Email Address: *</span><br>
        <input type="text" class="form-control" name="email" id="email" maxlength=256 required>
      </div>
      <div class="container col-lg-6">
        <span>Year: *</span><br>
        <input type="text" class="form-control" name="year" id="year" maxlength=10 required></input>
      </div>
      <div class="container col-lg-6">
        <span>Employer: </span><br>
        <input type="text" class="form-control" name="employer" id="employer" maxlength=70></input>
      </div>
      <div class="container col-lg-6">
        <span>Interests: </span><br>
        <textarea type="text" class="form-control" name="interests" id="interests" value="" maxlength=140></textarea>
      </div>
      <div class="container col-lg-6">
        <span>Bio: </span><br>
        <textarea type="text" class="form-control" name="bio" id="bio" value="" maxlength=140></textarea>
      </div>
      <div class="col-lg-6">
        <span>Profile Picture: </span><br>
        <input type="file" class="form-control upload-file" name="profileimage" id="profileimage"></input>
        <br>          
      </div>
    <div class="col-lg-12">
      <hr>
      <button id="submitForm" disabled=true class="btn btn-primary pull-right">Submit</button>
    </div>
  </div>
  <br>
<script src='../public/static/js/create_account.js'></script>

<?php include("../includes/footer.php"); ?>