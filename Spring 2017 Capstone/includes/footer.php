  <!--Report Modal  NOTE: z-index:2147483646 keeps the modal in the foreground -->
  <div style="z-index:2147483646;" class="modal fade" id="sendbugreport" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <he5 style="color: black;">Report a Bug / Suggestion</he5>
        </div>
        <div class="modal-body">
          <h5 style="color: black;">Describe the issue:</h5>
          <textarea class="form-control" rows="3" cols="40" id="message" name="message" maxlength="350"></textarea>
          <br>
          <div id="bugreporterror" style="display:none; color:red; font-size: 1em;"><p>You must supply a reason for report.</p></div>
        </div>
        <div class="modal-footer">
          <a class="btn btn-default text-right" data-dismiss="modal">Close</a>
          <button onclick="sendBugReport()" class="btn btn-primary">Submit</button>
        </div>
      </div>
    </div>
  </div>

  <!-- About Section -->
  <section id="about" class="container content-section text-center">
    <div class="row">
      <div class="col-lg-8 col-lg-offset-2">
        <h2>About PharmGenius</h2>
        <p> Pharm Genius is a game being developed by Computer Science students at the University of Pittsburgh
          in coordination with the Pharmacy School as a way of fulfilling the capstone requirement.</p>
      </div>
    </div>
  </section>

  <footer>
    <div class="container text-center">
        <p>Copyright &copy; PharmGenius 2016-2017, All Rights Reserved</p>
    </div>
  </footer>

  <!-- Report Bug modal controller -->
  <script src="../public/static/js/bug_report.js"></script>

  <!-- Bootstrap -->
  <script src="../public/static/js/bootstrap.min.js"></script>

  <!-- Plugin JavaScript -->
  <script src="../public/static/js/jquery.easing.min.js"></script>

  <!-- Custom Theme JavaScript -->
  <script src="../public/static/js/grayscale.js"></script>

</body>
</html>

<?php
    // always close connection
    if (isset($connection)) {
      mysqli_close($connection);
    }
?>