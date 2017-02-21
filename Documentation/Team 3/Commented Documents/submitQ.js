function submit(selection){
    if (counter == numAnswered){                                // Bowen - i guess this is a sanity check - should always be true, else doesn't do anything
        clearTimeout(timerId); //stops timer
        var a1 = curr[counter].answer1;                         // Bowen - question texts
        var a2 = curr[counter].answer2;
        var a3 = curr[counter].answer3;
        var a4 = curr[counter].answer4;
        var exp = document.getElementById("explanation");       // Bowen - DOM element for explanation
        var popAns1 = document.getElementById('popupAns1');     // Bowen - DOM elements for the answers in the pop up - these are where the answers are put after the question is answered
        var popAns2 = document.getElementById('popupAns2');
        var popAns3 = document.getElementById('popupAns3');
        var popAns4 = document.getElementById('popupAns4');
        var s1 = parseInt(curr[counter].answer1Selections);     // Bowen - this is the number of times each answer has been selected - used for calculating stats
        var s2 = parseInt(curr[counter].answer2Selections);
        var s3 = parseInt(curr[counter].answer3Selections);
        var s4 = parseInt(curr[counter].answer4Selections);
        var total = s1+s2+s3+s4;                                // Bowen - the total number of answers to this question - used for calculating stats
        var s1p = Math.round((s1 / total) * 100);               // Bowen - calculate the percentage of the time that each answer was selected
        var s2p = Math.round((s2 / total) * 100);
        var s3p = Math.round((s3 / total) * 100);
        var s4p = 100-(s1p+s2p+s3p);                            // Bowen - I suppose it was done this way to avoid rounding errors?
        if (isNaN(s1p)) s1p=0;                                  // Bowen - Make sure each result is a number
        if (isNaN(s2p)) s2p=0;
        if (isNaN(s3p)) s3p=0;
        if (isNaN(s4p)) s4p=0;
        if (s4p<0){ s4p = 0; }                                  // Bowen - Make sure the last percentage is positive/zero
        var newResult = new result();                           // Bowen - this basically creates a new result object - the annoying thing is that they defined the result() function in quiz.html
                                                                //         for what seems like no reason - it's never used in quiz.html. result is defined as follows: 
                                                                
                                                                //         function result(){  //none of these constructor values should remain after proper code executes
                                                                //           this.qTxt = "Question Text Goes Here";
                                                                //           this.uAns = "Timeout by default";
                                                                //           this.points = 0;
                                                                //           this.correct = false;
                                                                //         }
        
        if (selection != curr[counter].answerid) {              // Bowen - selection is the passed in parameter of the answer number chosen. Answer ID is 1-4 pointing to the answer number that is correct
            score = 0;                                          // Bowen - question was incorrect - no score and set correct flag of result object to false
            newResult.correct = false;
        }
        else{
            if( "1" == curr[counter].answerid){                 // Bowen - why are conditions written backwards? Also this entire block seems deprecated because calcScore just returns 100
                score = calcScore(timeLeft,s1p);                //         See calcScore function in quiz.html. They don't seem to even care which one was chosen
                correctCount = correctCount+1;                  //         correctCount is defined in quiz.html and is used to track how many correct answers there were for the quiz
                newResult.correct = true;                       //         Set correct flag of object to true
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
        totalScore += score;                                    // Bowen - increment total score by score earned this question
        newResult.qTxt = curr[counter].question;
        if (selection == '1'){                                  // Bowen - ah, here they are actually looking at what answer was chosen
            newResult.uAns = a1;                                //       - I feel like this could all be simpler if these variables that have 4 versions would be arrays
        }                                                       //       - Just storing the chosen answer text in the object
        else if (selection == '2'){
            newResult.uAns = a2;
        }
        else if (selection == '3'){
            newResult.uAns = a3;
        }
        else if (selection == '4'){
            newResult.uAns = a4;
        }
        else{
            newResult.uAns = '<i class="fa fa-clock-o" aria-hidden="true"> </i> Timeout';   // Bowen - question timed out, now we store HTML saying timeout in the answer text?
        }
        newResult.points = score;                                                           // Bowen - stores the score in the result object
        

        var newResLine1 = "<div class='container'><hr><span class='alignleft'>";            // Bowen - this sections creates the results page - it's ugly. This entire section is hidden until quiz done
        newResLine1 = newResLine1.concat(counter+1);                                        // Bowen - create new div for the results
        newResLine1 = newResLine1.concat(". ");
        newResLine1 = newResLine1.concat(newResult.qTxt);                                   // Bowen - stores question number, then text e.g. 1. Where's the beef?
        if (curr[counter].explanation != 'None'){
            newResLine1 = newResLine1.concat("</br><span style='color:#808080'>");          // Bowen - append the explanation if there is one - will need to update check because ours might not be 'None'
            newResLine1 = newResLine1.concat(curr[counter].explanation);
            newResLine1 = newResLine1.concat('</span>');
        }
        if (newResult.correct){                                                             // Bowen - if answer was correct, it's colored green
            var newResline2 = "</span><span class='aligncenterleft' style='color:green;'>"; // Bowen - lines state question, answer selected, correct answer, points earned
            newResline2 = newResline2.concat(newResult.uAns);
            var newResline3 = "</span><span class='alignright' style='color:green;'>+";     // Bowen - the + is so the points earned say +100
            newResline3 = newResline3.concat(newResult.points);
            var newResline4 = "&nbsp;&nbsp;&nbsp;</span></br></div>";
        }
        else{
            var newResline2 = "</span><span class='aligncenterleft' style='color:red;'>";   // Bowen - if answer was incorrect it is colored red.
            newResline2 = newResline2.concat(newResult.uAns);
            var newResline3 = "</span><span class='alignright' style='color:red;'>";
            newResline3 = newResline3.concat(newResult.points);
            var newResline4 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></br></div>";
        }

        var newResLineAnswer = "</span><span class='aligncenterright'>";                    // Bowen - the correct answer of the question
        if( "1" == curr[counter].answerid){
            newResLineAnswer = newResLineAnswer.concat(a1);
        }
        else if( "2" == curr[counter].answerid){
            newResLineAnswer = newResLineAnswer.concat(a2);
        }
        else if( "3" == curr[counter].answerid){
            newResLineAnswer = newResLineAnswer.concat(a3);
        }
        else if( "4" == curr[counter].answerid){
            newResLineAnswer = newResLineAnswer.concat(a4);
        }

        var resultsTable = document.getElementById('quizResults');

        // Bowen                                          Q text        selected ans  correct ans        pts earned    separating space
        resultsTable.innerHTML = resultsTable.innerHTML + newResLine1 + newResline2 + newResLineAnswer + newResline3 + newResline4; // Bowen - append to results html
        //resultsTable.innerHTML = resultsTable.innerHTML + "tesssst";
        //userResults.push(newResult);
        popAns1.innerHTML = a1 + " (" + s1p + "%)";         // Bowen - now we take care of screen after question is answered
        popAns2.innerHTML = a2 + " (" + s2p + "%)";         //         displays answer and percent of time chosen
        popAns3.innerHTML = a3 + " (" + s3p + "%)";
        popAns4.innerHTML = a4 + " (" + s4p + "%)";
        exp.innerHTML = curr[counter].explanation;
        if( "1" == curr[counter].answerid){                 // Bowen - color the correct answer green
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
            popAns1.style.fontWeight = "bold";              // Bowen - bold the selected answer - we may want make it more apparent if you answered the question correctly
        }                                                   //         I'm not sure the bold is doing enough to make this apparent
        if( 2 == selection){
            popAns2.style.fontWeight = "bold";
        }
        if( 3 == selection){
            popAns3.style.fontWeight = "bold";
        }
        if( 4 == selection){
            popAns4.style.fontWeight = "bold";
        }
        var header = document.getElementById('title');      // Bowen - the DOM object with the header that indicates if incorrect or correct
        $('#results').modal({ backdrop: 'static',keyboard: false });    
        //send selection back to python
        if(selection == curr[counter].answerid){ //changes the header to green if correct
            header.innerHTML = "<h3 style='color:green; display:inline;'>Correct (+" + score + " pts)</h3>";
            //var snd = new Audio("/static/sounds/smw_message_block.wav");
            //snd.play();
            $('#results').modal('show');    // Bowen - show the results modal div in quiz.html - can be moved out of the if
            //snd.currentTime=0;
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
            //var snd = new Audio("/static/sounds/smw_yoshi_spit.wav");
            //snd.play();
            //snd.currentTime=0;
            $('#results').modal('show');    // Bowen - show the results modal div in quiz.html
            sendAnswer(userid,questkey,selection, score);
        }
        numAnswered++;  // Bowen - increment number answered - defined in quiz.html
    }
    else{}
}
