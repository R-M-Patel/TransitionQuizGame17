  var categoryList;

  // update the tables on the screen
  function loadTables() {
    $.each(categoryList, function(key, value) {
      if (value.active_flag == 'Y') {
        var hidden = "<input type='hidden' name='cat' value='"+value.category_id+"'></input>";
        var removeButton = "<button class='btn btn-danger' onclick='removeCategory("+value.category_id+")'>REMOVE</button>";
        $('#acceptedBoard tbody').append("<tr><td>"+hidden+removeButton+"</td><td>"+value.category_name+"</td></tr>");
      } else {
        var hidden = "<input type='hidden' name='cat' value='"+value.category_id+"'></input>";
        var addButton = "<button class='btn btn-success' onclick='addCategory("+value.category_id+")'>ADD</button>";
        var deleteButton = "<button class='btn btn-danger' onclick='deleteCategory("+value.category_id+")'>DELETE</button>";
        $('#newBoard tbody').append("<tr><td>"+hidden+addButton+"</td><td>"+hidden+deleteButton+"</td><td>"+value.category_name+"</td></tr>");
      }      
    });
  }

  // reset the tables
  function clearTables() {
    $('#acceptedBoard tbody').empty();
    $('#newBoard tbody').empty();
  }

  // get the categories from the database
  function getCategories() {
    $.ajax({
      url: "../includes/ajax_calls.php",
      type: "get",
      data: {
        get_action: "get_categories"
      },
      success: function(data) {
        categoryList = JSON.parse(data);
        loadTables();
      },
      error: function(xhr) {
        alert(xhr);
      }
    });
  }

  function updateCategoryActiveStatus(categoryId, activeFlag) {
    var postData = {
      "action": "update_category_active_status",
      "category_id": categoryId,
      "active_flag": activeFlag
    };

    console.log(postData);

    $.ajax({
      type: "POST",
      url: "../includes/ajax_calls.php",
      data: postData,
      dataType: "text",
      success: function(data) { 
        clearTables();
        getCategories();
      },
      error: function(jqXHR, textStatus, error) { alert("Error"); }
    });
  }

  // set a category to inactive
  function removeCategory(categoryId) {
    updateCategoryActiveStatus(categoryId, "N");
  }

  // set a category to active
  function addCategory(categoryId) {
    updateCategoryActiveStatus(categoryId, "Y");
  }

  // delete a category
  function deleteCategory(categoryId) {
    var message = "Do you really wish to delete this category?";
    if (confirm(message)) {

    }
  }

  $(document).ready(function() {
    getCategories();    
  }); 