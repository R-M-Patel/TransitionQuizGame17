function submit(selection){
    if (counter == numAnswered){
        clearTimeout(timerId); //stops timer
        var a1 = curr[counter].answer1;
        var a2 = curr[counter].answer2;
        var a3 = curr[counter].answer3;
        var a4 = curr[counter].answer4;
        var exp = document.getElementById("explanation");
        var popAns1 = document.getElementById('popupAns1');
        var popAns2 = document.getElementById('popupAns2');
        var popAns3 = document.getElementById('popupAns3');
        var popAns4 = document.getElementById('popupAns4');
        var s1 = parseInt(curr[counter].answer1Selections);
        var s2 = parseInt(curr[counter].answer2Selections);
        var s3 = parseInt(curr[counter].answer3Selections);
        var s4 = parseInt(curr[counter].answer4Selections);
        var total = s1+s2+s3+s4;
        var s1p = Math.round((s1 / total) * 100);
        var s2p = Math.round((s2 / total) * 100);
        var s3p = Math.round((s3 / total) * 100);
        var s4p = 100-(s1p+s2p+s3p);
        if (isNaN(s1p)) s1p=0;
        if (isNaN(s2p)) s2p=0;
        if (isNaN(s3p)) s3p=0;
        if (isNaN(s4p)) s4p=0;
        if (s4p<0){ s4p = 0; }
        var newResult = new result();
        if (selection != curr[counter].answerid){
            score = 0;
            newResult.correct = false;
        }
        else{
            if( "1" == curr[counter].answerid){
                score = calcScore(timeLeft,s1p);
                correctCount = correctCount+1;
                newResult.correct = true;
            }
            if( "2" == curr[counter].answerid){
                score = calcScore(timeLeft,s2p);
                correctCount = correctCount+1;
                newResult.correct = true;
            }
            if( "3" == curr[counter].answerid){
                score = calcScore(timeLeft,s3p);
                correctCount = correctCount+1;
                newResult.correct = true;
            }
            if( "4" == curr[counter].answerid){
                score = calcScore(timeLeft,s4p);
                correctCount = correctCount+1;
                newResult.correct = true;
            }
        }
        totalScore += score;
        newResult.qTxt = curr[counter].question;
        if (selection == '1'){
            newResult.uAns = a1;
        }
        else if (selection == '2'){
            newResult.uAns = a2;
        }
        else if (selection == '3'){
            newResult.uAns = a3;
        }
        else if (selection == '4'){
            newResult.uAns = a1;
        }
        else{
            newResult.uAns = 'Timeout';
        }
        newResult.points = score;
        var newResLine1 = "<div class='container'><hr><span class='alignleft'>";
        newResLine1 = newResLine1.concat(counter+1);
        newResLine1 = newResLine1.concat(". ");
        newResLine1 = newResLine1.concat(newResult.qTxt);
        if (newResult.correct){
            var newResline2 = "</span><span class='aligncenter' style='color:green;'>";
            newResline2 = newResline2.concat(newResult.uAns);
            var newResline3 = "</span><span class='alignright' style='color:green;'>+";
            newResline3 = newResline3.concat(newResult.points);
            var newResline4 = "&nbsp;&nbsp;&nbsp;</span></br></div>";
        }
        else{
            if (curr[counter].explanation != 'None'){
                newResLine1 = newResLine1.concat("</br><span style='color:#808080'>");
                newResLine1 = newResLine1.concat('Explanation: ');
                newResLine1 = newResLine1.concat(curr[counter].explanation);
                newResLine1 = newResLine1.concat('</span>');
            }
            var newResline2 = "</span><span class='aligncenter' style='color:red;'>";
            newResline2 = newResline2.concat(newResult.uAns);
            var newResline3 = "</span><span class='alignright' style='color:red;'>";
            newResline3 = newResline3.concat(newResult.points);
            var newResline4 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></br></div>";
        }
        var resultsTable = document.getElementById('quizResults');
        resultsTable.innerHTML = resultsTable.innerHTML + newResLine1 + newResline2 + newResline3 + newResline4;
        //resultsTable.innerHTML = resultsTable.innerHTML + "tesssst";
        //userResults.push(newResult);
        popAns1.innerHTML = a1 + " (" + s1p + "%)";
        popAns2.innerHTML = a2 + " (" + s2p + "%)";
        popAns3.innerHTML = a3 + " (" + s3p + "%)";
        popAns4.innerHTML = a4 + " (" + s4p + "%)";
        exp.innerHTML = curr[counter].explanation;
        if( "1" == curr[counter].answerid){
            popAns1.style.color = "#00933B";
        }
        if( "2" == curr[counter].answerid){
            popAns2.style.color = "#00933B";
        }
        if( "3" == curr[counter].answerid){
            popAns3.style.color = "#00933B";
        }
        if( "4" == curr[counter].answerid){
            popAns4.style.color = "#00933B";
        }
        if( 1 == selection){
            popAns1.style.fontWeight = "bold";
        }
        if( 2 == selection){
            popAns2.style.fontWeight = "bold";
        }
        if( 3 == selection){
            popAns3.style.fontWeight = "bold";
        }
        if( 4 == selection){
            popAns4.style.fontWeight = "bold";
        }
        var header = document.getElementById('title');
        $('#results').modal({ backdrop: 'static',keyboard: false });
        //send selection back to python
        if(selection == curr[counter].answerid){ //changes the header to green if correct
            header.innerHTML = "<h3 style='color:green; display:inline;'>Correct (+" + score + " pts)</h3>";
            var snd = new Audio("/static/sounds/smw_message_block.wav");
            snd.play();
            $('#results').modal('show');
            snd.currentTime=0;
            sendAnswer(userid,questkey,selection, score);
            //logic for score in here
        }
        else{ //red if incorrect
            if (selection == 5){
                header.innerHTML = "<h3 style='color:red; display:inline;'>You Ran Out of Time (+0 pts)</h3>";
            }
            else{
                header.innerHTML = "<h3 style='color:red; display:inline;'>Incorrect (+0 pts)</h3>";
            }
            var snd = new Audio("/static/sounds/smw_yoshi_spit.wav");
            snd.play();
            snd.currentTime=0;
            $('#results').modal('show');
            sendAnswer(userid,questkey,selection, score);
        }
        numAnswered++;
    }
    else{}
}
