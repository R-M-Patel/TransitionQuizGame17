// validate username
function usernameValidation(){
  var illegalChars = /\W/; // this is regex that excludes anything but alphanumeric and underscores
  var username = $('#username').val();
  if (username.length<3){
    $('#exists').hide();
    $('#doesNotExist').hide();
    $('#invalid').show();
    $('#submitForm').prop('disabled', true);
    return;
  }
  if (illegalChars.test(username)){ //tests to make sure username has valid characters
    $('#invalid').show();
    $('#exists').hide();
    $('#doesNotExist').hide();
    $('#submitForm').prop('disabled', true);
  }
  else{
    $('#submitForm').prop('disabled', false);
    $('#invalid').hide();
  }
}

// on document ready
$(document).ready(function() {
  // register events
  $("#username").on("keyup", usernameValidation);
  $("#submitForm").on("click", validateForm);

  // sets up a timer. if it has been 1 second since last key press,
  // an ajax call is made to the database to determine if the username is available
  var x_timer;
  $("#username").keyup(function (e){
    clearTimeout(x_timer);
    var user_name = $(this).val();
    x_timer = setTimeout(function() {
      check_username_ajax(user_name);
    }, 1000);
  });

  // performs the same as above, only for email address instead of username
  $("#email").keyup(function (e) {
    clearTimeout(x_timer);
    var email = $(this).val();
    x_timer = setTimeout(function(){
      check_email_ajax(email);
    }, 1000);      
  });

  // check if the email has been taken or not
  function check_email_ajax(email) {
    $.ajax({
      url: "../includes/ajax_calls.php",
      type: "get",
      data: {
        get_action: "check_email_availability",
        email: email
      },
      success: function(data) {
        var results = JSON.parse(data);            
        if (results.exists == "false") {
          $('#doesNotExist').hide();
          $('#emailtaken').hide();
          $('#exists').show();
          $('#submitForm').prop('disabled', false);
        }
        if (results.exists == "true") {
          $('#exists').hide();
          $('#emailtaken').show();
          $('#doesNotExist').hide();
          $('#submitForm').prop('disabled', true);
        }
      },
      error: function(xhr) {
        alert(xhr);
      }
    });
  }

  // check if the user name is available
  function check_username_ajax(username){
    if (username.length<3){ //dont want to send names <3 characters
      $('#exists').hide();
      $('#doesNotExist').hide();
      $('#invalid').show();
      $('#submitForm').prop('disabled', true);
      return;
    }

    var illegalChars = /\W/;
    if (illegalChars.test(username)){ //dont want to send characters with illegal characters
      $('#invalid').show();
      $('#submitForm').prop('disabled', true);
      $('#exists').hide();
      $('#doesNotExist').hide();
      return;
    }

    $.ajax({
      url: "../includes/ajax_calls.php",
      type: "get",
      data: {
        get_action: "check_username_availability",
        username: username
      },
      success: function(data) {
        var results = JSON.parse(data);
        if (results.exists == "false") {
          $('#doesNotExist').hide();
          $('#exists').show();
          $('#submitForm').prop('disabled', false);
        }
        if (results.exists == "true") {
          $('#exists').hide();
          $('#doesNotExist').show();
          $('#submitForm').prop('disabled', true);
        }
      },
      error: function(xhr) {
        alert(xhr);
      }
    });
  }
});

// upload an image to the server
function uploadImage(username) {
  var input = document.getElementById("profileimage");
  file = input.files[0];

  if (file != undefined) {
    formData = new FormData();
    if (!!file.type.match(/image.*/)) {
      formData.append("profileimage", file);
      formData.append("action", "upload_image");
      formData.append("username", username);

      $.ajax({
        url: "../includes/ajax_calls.php",
        type: "POST",
        data: formData,
        processData: false,
        contentType: false,
        success: function(data) {
          //don't need to do anything
        }
      });
    }
  }
}

// perform basic validation
function validateForm() { 
  var username = $("#username").val();
  var password = $("#createpassword").val();
  var retype = $("#createpasswordretype").val();

  if (username.length<3) { //dont want to send names <3 characters
    alert("Username must be at least three characters long.");
    return;
  }
  var illegalChars = /\W/;
  if (illegalChars.test(username)) {//dont want to send characters with illegal characters
    alert("Username must contain only uppercase and lowercase characters, numbers, and underscores.");
    return;
  }
  if (password != retype) {
    alert("Passwords do not match. Please retype passwords.");
    return;
  }
  if (!$("#name").val()) {
    alert("Must provide name.");
    return;
  }
  if (!$("#year").val()) {
    alert("Must provide year.");
    return;
  }
  if (!$("#email").val()) {
    alert("Must provide email address.");
    return;
  }

  // we have passed validation - send data to the database to create account
  var postData = {
    "action": "create_account",
    "username": username,
    "password": password,
    "name": $("#name").val(),
    "year": $("#year").val(),
    "employer": $("#employer").val(),
    "bio": $("#bio").val(),
    "interests": $("#interests").val(),
    "email_address": $("#email").val()
  };

  $.ajax({
    type: "POST",
    url: "../includes/ajax_calls.php",
    data: postData,
    dataType: "text",
    success: function(text) {
      uploadImage(username);
      alert("Account created.");
      window.location.replace("login.php");
    },
  });
}