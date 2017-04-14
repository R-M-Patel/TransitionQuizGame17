<?php session_start(); ?>
<?php require_once("../includes/db_connection.php"); ?>
<?php require_once("../includes/functions.php"); ?>
<?php confirm_login_status(); ?>
<?php include("../includes/header.php"); ?>
<script src="static/js/dropdowns.js"></script>

</head>
<body>
  <?php echo get_navbar(); ?>
  <br><br><br><br>  
  <div class = "container">
    <h2 style="text-align: center;">New Question Submission</h2>
    <hr>
    <font size=5>
      <div class='col-md-6'>
        <span class="cat">Select A Category:&nbsp;</span>
        <select class="cat" name="category" id="catdropdown" method="POST" required></select>
      </div>
      <div class='col-md-6'>
        <span class="cat">Select A Quiz:&nbsp;</span>
        <select class="cat" name="subcategory"  id="subdropdown" method="POST" required></select>      
      </div>
      <div class="col-xs-12" style="text-align:center;">
          <a class="btn btn-primary" style="margin: 15px;" onclick="displayCategoryModal()" data-toggle="modal">Submit Category / Quiz</a>
      </div>
      <hr>
      <div class="col-xs-12" >
        <textarea type="text" name="questiontext" placeholder="Enter question here..." class="form-control" rows="6" METHOD=POST maxlength="144" id="questionText" required></textarea><br/>
      </div>
      <hr>
      Import Image:
      <input type="file" class="form-control upload-file" name="file" id="Location"></input><br/>
      Explanation:
      <textarea type="text" name="explanation" class="form-control" rows="5" maxlength="750" id="explanation"></textarea>
      <hr>  
      <div class="container">
        <div class="col-sm-3" style="text-align: center;">
          <input type="textarea" class="red-text" style="width: 100%;" placeholder="Answer #1" method="POST" name="answer1" maxlength="30" id="answer1" required></input>
        </div>
        <div class="col-sm-3" style="text-align: center;">
          <input type="textarea" class="blue-text" style="width: 100%;" placeholder="Answer #2" method="POST" name="answer2" maxlength="30" id="answer2" required></input>
        </div>
        <div class="col-sm-3" style="text-align: center;">
          <input type="textarea" class="green-text" style="width: 100%;" placeholder="Answer #3" method="POST" name="answer3" maxlength="30" id="answer3" required></input>
        </div>
        <div class="col-sm-3" style="text-align: center;">
          <input type="textarea" class="yellow-text" style="width: 100%;" placeholder="Answer #4" method="POST" name="answer4" maxlength="30" id="answer4" required></input>
        </div>
          <br><br>
          Select the correct answer:<br>
          <div class="col-sm-3">
            <button type="submit" style="width:100%; height: 100px; border-radius: 15px;" name="answerid" value=1 class="btn btn-danger submit-a-button" id="select1">1</button><br/><br/>
          </div>
          <div class="col-sm-3">
            <button type="submit" style="width:100%; height: 100px; border-radius: 15px;" name="answerid" value=2 class="btn btn-info submit-a-button" id="select2">2</button><br/><br/>
          </div>
          <div class="col-sm-3">
            <button type="submit" style="width:100%; height: 100px; border-radius: 15px;" name="answerid" value=3 class="btn btn-success submit-a-button" id="select3">3</button><br/><br/>
          </div>
          <div class="col-sm-3">
            <button type="submit" style="width:100%; height: 100px; border-radius: 15px;" name="answerid" value=4 class="btn btn-warning submit-a-button" id="select4">4</button><br/><br/>
          </div>
      </div>
  </div>
<br/>

<!--Suggest category Modal-->
<div style="z-index:2147483646;" class="modal fade" id="submitcat" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <he5>Category Creation</he5>
      </div>
      <div class="modal-body">
        Main Category:<br><br>
        <div style="text-align:center;">
          <select class="mainCat" name="newCatDropdown" id="newcatdropdown" method="POST" required>
            <option value='cat'>New Main Category</option>
          </select>
        </div>
        <input class="form-control" id="category" maxlength="30" type="text" required></input>
        <br>
        Quiz:<br><br>
        <input class="form-control" id="subcategory" maxlength="30" type="text" required></input>
        <br>
      </div>
      <div class="modal-footer">
        <a class="btn btn-default text-right" data-dismiss="modal">Close</a>
        <button class="btn btn-primary" onclick="submitCategory()">Submit</button>
      </div>
    </div>
  </div>
</div>

<!--Confirmation Modal-->
<div style="z-index:2147483646;" class="modal fade" id="confirm" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header" style="text-align:center">
        <h1 style="display:inline">Question Submitted Successfully!</h1>
      </div>
      <div class="modal-body" style="text-align:center">
        <p>Questions are automatically accepted for beta testers.  After PharmGenius is live, you will have to vote on questions before they become active.</p>
      </div>
      <div class="modal-footer" style="text-align: center;">
        <a class="btn btn-success" style="border-radius: 25px;" data-dismiss="modal" id="ok"><h2 class="link-button">Continue</h2></a><br/>
      </div>
    </div>
  </div>
</div>

<script src="../public/static/js/submit_new.js"></script>

<?php include("../includes/footer.php"); ?>