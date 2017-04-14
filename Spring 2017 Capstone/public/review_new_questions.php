<?php session_start(); ?>
<?php require_once("../includes/db_connection.php"); ?>
<?php require_once("../includes/functions.php"); ?>
<?php confirm_login_status(); ?>

<?php include("../includes/header.php"); ?>

<script src="static/js/jquery.easing.min.js"></script>
</head>
<body>
  <?php echo get_navbar(); ?>
  <!-- Scripts -->
  <script>
  //AJAX
  function sendBugReport(){
      $('#sendbugreport').modal('hide');
      var message = document.getElementById('message').value;
      //clear report question text box
      document.getElementById('message').value= "";
      $.ajax({
                  type: "POST",
                  url: "/reportBug",
                  contentType: "application/json; charset=utf-8",
                  data: JSON.stringify({"message": message})
             });
      confirm('Report Sent'); //maybe do something else here dunno what
  }
  </script>
  <link rel="stylesheet" type="text/css" href="./static/css/dataTables.bootstrap.min.css">
  <script type="text/javascript" src="./static/js/datatables.min.js"></script>
  <script>
    $(document).ready(function() {
          var table = $('#example').DataTable();
  } );
  </script>
  <br/><br/><br/><br/>
  <div class="container" style="text-align: center;">
      <h2>Questions Under Review</h2>
      <hr>
  </div>
  <div class="container table-responsive">
    <table id="example" class="table table-bordered table-hover" cellspacing="0" width="100%">
        <thead>
          <tr>
            <th>Question</th>
            <th>Category</th>
            <th>Subcategory</th>
          </tr>
        </thead>

        <tfoot>
          <tr>
            <th>Question</th>
            <th>Category</th>
            <th>Subcategory</th>
          </tr>
        </tfoot>

        <tbody>

        </tbody>
    </table>
  </div>
