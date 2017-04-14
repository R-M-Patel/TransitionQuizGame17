$(document).ready(function(){
    var curr = {{trueCatList|safe}};
    var falseList = {{falseCatList|safe}};
    $.each(curr, function(key, value) {
        var newNo1 = "<form method='post' style='display:inline-block' class='horizontal-form' action='/removeNewCategory'>";
        var newNo2 = "<input type='hidden' name='cat' value='"+value.category+"'></input>";
        var newNo3 = "<button class='btn btn-danger' type='submit'>REMOVE</button></form>";
        $('#acceptedBoard tbody').append("<tr><td>"+newNo1+newNo2+newNo3+"</td><td>"+value.category+"</td></tr>");
    });
    $.each(falseList, function(key, value) {
        var newNo1 = "<form method='post' style='display:inline-block' class='horizontal-form' action='/addNewCategory'>";
        var newNo2 = "<input type='hidden' name='cat' value='"+value.category+"'></input>";
        var newNo3 = "<button class='btn btn-success' type='submit'>ADD</button></form>";
        var newNo5 = "<form method='post' style='display:inline-block' class='horizontal-form' onsubmit=\"return confirm('Do you really want to delete this category?');\" action='/deleteCategory'>";
        var newNo4 = "<button class='btn btn-danger' type='submit'>DELETE</button></form>";
        $('#newBoard tbody').append("<tr><td>"+newNo1+newNo2+newNo3+"</td><td>"+newNo5+newNo2+newNo4+"</td><td>"+value.category+"</td></tr>");
        console.log(newNo5);
    });
});
