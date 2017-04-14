// stores the original profile data
var originalData;
$(document).ready(function() {
  // store data for later use
  var name = document.getElementById('name').value
  var year = document.getElementById('year').value;
  var interests = document.getElementById('interests').value;
  var employer = document.getElementById('employer').value;
  var bio = document.getElementById('bio').value;    

  originalData = {
    name: name,
    year: year,
    interests: interests,
    employer: employer,
    bio: bio
  };

  // register events for fields 
  $("#oldpassword").on("keypress", function() {
    if ($("#oldpassword").val().length >= 2) {
      $("#oldpassword").removeClass("profileError");
    }
  });
  $("#newpassword").on("keypress", function() {
    if ($("#newpassword").val().length >= 2) {
      $("#newpassword").removeClass("profileError");
    }
  });
  $("#retypepassword").on("keypress", function() {
    if ($("#retypepassword").val().length >= 2) {
      $("#retypepassword").removeClass("profileError");
    }
  });

  // register button click events
  $("#submit-password").on("click", updatePassword);
  $("#submit-profile").on("click", updateProfile);
  $("#show-password-modal").on("click", showPasswordModal);
  $("#show-profile-modal").on("click", initFields);
});

// initialize modal fields with profile data
function initFields() {
  document.getElementById('name').value = originalData.name;
  document.getElementById('year').value = originalData.year;
  document.getElementById('interests').value = originalData.interests;
  document.getElementById('employer').value = originalData.employer;
  document.getElementById('bio').value = originalData.bio;

  $("#editprofile").modal('show');
}

// attempt to update profile
function updateProfile() {
  if (areFieldsValid()) {
    submitProfileData();
  }
}

// upload image to the database
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
          $("#profileimg").attr("src", data);
          $(".profile-small").attr("src", data); // update image on screen
        }
      });
    }
  }
}

// submit profile data to database
function submitProfileData() {
  var name = document.getElementById('name').value
  var year = document.getElementById('year').value;
  var interests = document.getElementById('interests').value;
  var employer = document.getElementById('employer').value;
  var bio = document.getElementById('bio').value;
  var username = document.getElementById('usernameheader').innerHTML;
  username = username.substr(0, username.indexOf("\'"));

  var postData = {
    "action": "submit_profile",
    "full_name": name,
    "year": year,
    "interests": interests,
    "employer": employer,
    "bio": bio
  };

  $.ajax({
    type: "POST",
    url: "../includes/ajax_calls.php",
    data: postData,
    dataType: "text",
    success: function(data) {
      uploadImage(username);
    }, // don't need to do anything else on success
    error: function(jqXHR, textStatus, error) { }
  });

  originalData.name = name;
  originalData.year = year;
  originalData.interests = interests;
  originalData.employer = employer;
  originalData.bio = bio;

  updateScreen();
  $("#editprofile").modal('hide');
  $(document).trigger("select");
}

// update profile screen with changed data
function updateScreen() {
  document.getElementById('displayName').innerHTML = originalData.name;
  document.getElementById('displayYear').innerHTML = originalData.year;
  document.getElementById('displayInterests').innerHTML = originalData.interests;
  document.getElementById('displayEmployer').innerHTML = originalData.employer;
  document.getElementById('displayBio').innerHTML = originalData.bio;
}

// valdiate name and year fields
function areFieldsValid() {
  var name = document.getElementById('name').value;
  var year = document.getElementById('year').value;
  var isValid = true;

  if (name == null || name.length < 3) {
    $("#name").addClass("profileError");
    isValid = false;
  }

  if (year == null || year.length < 3) {
    $("#year").addClass("profileError");
    isValid = false;
  }

  return isValid;
}

// display the password change modal
function showPasswordModal() {
  $("#changepassword").modal('show');
  $("#newpassword").removeClass("profileError");
  $("#retypepassword").removeClass("profileError");
  $("#oldpassword").removeClass("profileError");

  document.getElementById('newpassword').value = "";
  document.getElementById('retypepassword').value = "";
  document.getElementById('oldpassword').value = "";
}

// attempt to update the password
function updatePassword() {
  if (doNewPasswordsMatch() && arePasswordsFilledOut()) {
    changePasswordInDatabase();      
  }
}

// make sure data is being submitted
function arePasswordsFilledOut() {
  var oldPass = document.getElementById('oldpassword').value;
  var newPass = document.getElementById('newpassword').value;
  var retype = document.getElementById('retypepassword').value;
  var isValid = true;

  if (oldPass == null || oldPass.length < 3) {
    $("#oldpassword").addClass("profileError");
    isValid = false;
  }

  if (newPass == null || newPass.length < 3) {
    $("#newpassword").addClass("profileError");
    isValid = false;
  }

  if (retype == null || retype.length < 3) {
    $("#retypepassword").addClass("profileError");
    isValid = false;
  }

  return isValid;
}

// submit password change to database
function changePasswordInDatabase() {
  var oldPassword = document.getElementById('oldpassword').value
  var newPassword = document.getElementById('newpassword').value;

  var postData = {
    "action": "update_password",
    "old_password": oldPassword,
    "new_password": newPassword    
  };

  $.ajax({
    type: "POST",
    url: "../includes/ajax_calls.php",
    data: postData,
    dataType: "text",
    success: function(data) { 
      if (data.includes("false")) {
        $("#oldpassword").addClass("profileError");
      } else {
        alert("Password changed");
        $("#changepassword").modal('hide');
      }
    }, // don't need to do anything else on success
    error: function(jqXHR, textStatus, error) { }
  });
}

// determine if new passwords match each other
function doNewPasswordsMatch() {
  var password = document.getElementById('newpassword').value;
  var retype = document.getElementById('retypepassword').value;
  var isValid;

  if (password == retype) {
    isValid = true;      
  } else {
    $("#newpassword").addClass("profileError");
    $("#retypepassword").addClass("profileError");
    isValid = false;
  }

  return isValid;
}