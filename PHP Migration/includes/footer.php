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
            <p>Copyright &copy; PharmGenius 2016, All Rights Reserved</p>
        </div>
    </footer>

    <!-- jQuery -->  
    <!-- moved to header -->
    <!-- <script src="../public/static/js/jquery.js"></script> -->

    <!-- Bootstrap -->
    <script src="../public/static/js/bootstrap.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="../public/static/js/jquery.easing.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <!-- Commented this out, not sure it is needed. -->
    <!-- <script src="../public/static/js/grayscale.js"></script> -->

</body>
</html>

<?php
    // always close connection
    if (isset($connection)) {
      mysqli_close($connection);
    }
?>