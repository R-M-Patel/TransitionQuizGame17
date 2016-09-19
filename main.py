import logging
import os
import webapp2
import models
import time
import json

from google.appengine.api import images
from google.appengine.api import mail
from google.appengine.api import users
from google.appengine.ext import ndb
from google.appengine.ext import blobstore
from google.appengine.ext.webapp import template
from google.appengine.api import mail
from google.appengine.ext.webapp import blobstore_handlers

###############################################################################
# We'll just use this convenience function to retrieve and render a template.
def render_template(handler, templatename, templatevalues={}):
  path = os.path.join(os.path.dirname(__file__), 'templates/' + templatename)
  html = template.render(path, templatevalues)
  handler.response.out.write(html)


###############################################################################
def get_user_email():
    result = None
    user = users.get_current_user()
    if user:
        result = user.email()
    return result

def get_user_id():
    result = None
    user = users.get_current_user()
    if user:
        result = user.user_id()
    return result

class MainPageHandler(webapp2.RequestHandler):
    def get(self):
        id = get_user_id()
        is_admin = 0
        if users.is_current_user_admin():
            is_admin = 1
        logging.warning(models.getCategoryList())
        newList = models.getCategoryList()
        page_params = {
            'catList': newList,
            'user_email': get_user_email(),
            'login_url': users.create_login_url('/firstLogin'),
            'logout_url': users.create_logout_url('/'),
            'user_id': id,
            'admin' : is_admin
        }
        render_template(self, 'index.html', page_params)

class LoginPageHandler(webapp2.RequestHandler):
    def get(self):
        id = get_user_id()
        user = models.getUser(id)
        if user is None:
            self.redirect('/profile?id=' + id)
        else:
            self.redirect('/')

class SubmitPageHandler(webapp2.RequestHandler):
    def get(self):
        id = get_user_id()
        is_admin = 0
        if users.is_current_user_admin():
            is_admin = 1
        if id is not None:
            q = models.check_if_user_exists(id)
            if q == None:
                page_params = {
                    'upload_url': blobstore.create_upload_url('/profile'),
                    'user_email': get_user_email(),
                    'login_url': users.create_login_url(),
                    'logout_url': users.create_logout_url('/'),
                    'user_id': get_user_id(),
                    'profile': models.getUser(id),
                    'admin': is_admin
                }
                render_template(self, 'createProfile.html' ,page_params)
                return
        newList = models.getCategoryList()
        page_params = {
            'catList': newList,
            'upload_urlQ': blobstore.create_upload_url('/NewQuestion'),
            'user_email': get_user_email(),
            'login_url': users.create_login_url(),
            'logout_url': users.create_logout_url('/'),
            'user_id': id,
            'admin' : is_admin
        }
        render_template(self, 'newQuestionSubmit.html', page_params)

#Gets all of the information submitted by the user about a new question
class NewQuestion(blobstore_handlers.BlobstoreUploadHandler):
    def post(self):
        id = get_user_id()
        q = models.getUser(id)
        creator = q.username
        explanation = self.request.get('explanation')
        if not explanation:
            explanation = "No Explanation Provided"
        category = self.request.get('category')
        question = self.request.get('questiontext')
        answer1 = self.request.get('answer1')
        answer2 = self.request.get('answer2')
        answer3 = self.request.get('answer3')
        answer4 = self.request.get('answer4')
        answerid = self.request.get('answerid')
        try:
            upload_files = self.get_uploads()
            blob_info = upload_files[0]
            type = blob_info.content_type

            # if the uploaded file is an image
            if type in ['image/jpeg', 'image/png', 'image/gif', 'image/webp']:
                image = blob_info.key()
                questionID = models.createQuestion(category,
                        question,answer1,answer2,answer3,answer4,answerid,
                        explanation,creator,False,image)

            # if the uploaded file is not an image
            else:
                questionID = models.createQuestion(category,
                        question,answer1,answer2,answer3,answer4,answerid,
                        explanation,creator,False)

            self.redirect('/NewQuestion?id=' + questionID.urlsafe())

        # no image to upload
        except IndexError:
            questionID = models.createQuestion(category,
                    question,answer1,answer2,answer3,answer4,answerid,
                    explanation,creator,False)

        self.redirect('/NewQuestion?id=' + questionID.urlsafe())

    def get(self):
        id = self.request.get('id')
        page_params = {
            'questionID' : id
        }
        render_template(self, 'confirmationPage.html', page_params)

#Used for reviewing a single question, whether from the tables or from email
class ReviewSingleQuestion(blobstore_handlers.BlobstoreUploadHandler):
    def get(self):
        questionID = self.request.get('id')
        id = get_user_id()
        review = models.getQuestionFromURL(questionID)
        is_admin = 0
        if users.is_current_user_admin():
            is_admin = 1
        if id is not None:
            q = models.check_if_user_exists(id)
            if q == None:
                page_params = {
                    'upload_url': blobstore.create_upload_url('/profile'),
                    'user_email': get_user_email(),
                    'login_url': users.create_login_url(),
                    'logout_url': users.create_logout_url('/'),
                    'user_id': get_user_id(),
                    'profile': models.getUser(id),
                    'admin': is_admin
                }
                render_template(self, 'createProfile.html' ,page_params)
                return
        page_params = {
            'upload_urlQE': blobstore.create_upload_url('/ReviewQuestion?id=' + questionID),
            'user_email': get_user_email(),
            'login_url': users.create_login_url(),
            'logout_url': users.create_logout_url('/'),
            'user_id': id,
            'review': review,
            'admin' : is_admin
        }
        render_template(self, 'questionReview.html', page_params)
    def post(self):
        #try to upload an image
        try:
            upload_files = self.get_uploads()
            blob_info = upload_files[0]
            type = blob_info.content_type
            id = self.request.get('id')
            #explanation = models.getQuestionFromURL(id).explanation
            explanation = self.request.get('explanation')
            if not explanation:
                explanation = "None"
            category = models.getQuestionFromURL(id).category
            creator = models.getQuestionFromURL(id).creator
            questionIn = self.request.get('questiontext')
            answer1 = self.request.get('answer1')
            answer2 = self.request.get('answer2')
            answer3 = self.request.get('answer3')
            answer4 = self.request.get('answer4')
            answerid = self.request.get('answerid')
                # if the uploaded file is an image
            if type in ['image/jpeg', 'image/png', 'image/gif', 'image/webp']:
                image = blob_info.key()
                models.updateQuestion(id,category,questionIn,answer1,answer2,answer3,answer4,answerid,explanation,creator,True,image)

                # if the uploaded file is not an image
            else:
                models.updateQuestion(id,category,questionIn,answer1,answer2,answer3,answer4,answerid,explanation,creator,True, models.getQuestionFromURL(id).image_urlQ)

                self.redirect('/ReviewQuestion?id=' + id)
        # no image to upload
        except IndexError:
            id = self.request.get('id')
            #explanation = models.getQuestionFromURL(id).explanation
            explanation = self.request.get('explanation')
            if not explanation:
                explanation = "None"
            category = models.getQuestionFromURL(id).category
            creator = models.getQuestionFromURL(id).creator
            questionIn = self.request.get('questiontext')
            answer1 = self.request.get('answer1')
            answer2 = self.request.get('answer2')
            answer3 = self.request.get('answer3')
            answer4 = self.request.get('answer4')
            answerid = self.request.get('answerid')
            models.updateQuestion(id,category,questionIn,answer1,answer2,answer3,answer4,answerid,explanation,creator,True, models.getQuestionFromURL(id).image_urlQ)


        self.redirect('/ReviewQuestion?id=' + id)

#Brings up a table that displays information on the most recent 1000 questions
class ReviewNewQuestions(webapp2.RequestHandler):
    def get(self):
        id = get_user_id()
        #just loops and prints every question from query
        review = models.get_oldest_questions(False,False) #searches 1000 oldest invalid questions
        is_admin = 0
        if users.is_current_user_admin():
            is_admin = 1
        if id is not None:
            q = models.check_if_user_exists(id)
            if q == None:
                page_params = {
                    'upload_url': blobstore.create_upload_url('/profile'),
                    'user_email': get_user_email(),
                    'login_url': users.create_login_url(),
                    'logout_url': users.create_logout_url('/'),
                    'user_id': get_user_id(),
                    'profile': models.getUser(id),
                    'admin': is_admin
                }
                render_template(self, 'createProfile.html' ,page_params)
                return
        page_params = {
            'user_email': get_user_email(),
            'login_url': users.create_login_url(),
            'logout_url': users.create_logout_url('/'),
            'user_id': id,
            'review': review,
            'admin' : is_admin
        }
        render_template(self, 'reviewNewQuestions.html', page_params)

#Brings up a table that displays information on the most recent 1000 questions
class ReviewOldQuestions(webapp2.RequestHandler):
    def get(self):
        id = get_user_id()
        #just loops and prints every question from query
        review = models.get_oldest_questions(True,False)
        is_admin = 0
        if users.is_current_user_admin():
            is_admin = 1
        if id is not None:
            q = models.check_if_user_exists(id)
            if q == None:
                page_params = {
                    'upload_url': blobstore.create_upload_url('/profile'),
                    'user_email': get_user_email(),
                    'login_url': users.create_login_url(),
                    'logout_url': users.create_logout_url('/'),
                    'user_id': get_user_id(),
                    'profile': models.getUser(id),
                    'admin': is_admin
                }
                render_template(self, 'createProfile.html' ,page_params)
                return
        page_params = {
            'user_email': get_user_email(),
            'login_url': users.create_login_url(),
            'logout_url': users.create_logout_url('/'),
            'user_id': id,
            'review': review,
            'admin' : is_admin
        }
        render_template(self, 'viewDatabase.html', page_params)

#Created for populating the database with some answers,categories, and questions, for testing
#purposes, necessary to run before anything else works when databse is empty. /meanstackakalamestack
class Setup(webapp2.RequestHandler):
    def get(self):
        if not users.is_current_user_admin(): #stops from running this if user is not admin
            self.redirect("/")
            return
        if (len(models.get_oldest_questions(True,False)) > 3):
            self.redirect("/")
            return
        models.populateQuestions()
        models.populateAnswers()
        #models.createAnswer(get_user_id(),'1','2')
        id = get_user_id()
        is_admin = 0
        if users.is_current_user_admin():
            is_admin = 1
        q = models.check_if_user_exists(id)
        page_params = {
            'user_email': get_user_email(),
            'login_url': users.create_login_url(),
            'logout_url': users.create_logout_url('/'),
            'user_id': id,
            'admin' : is_admin
        }
        render_template(self, 'index.html', page_params)

#Handles everything that happens on the profile page
class ProfileHandler(blobstore_handlers.BlobstoreUploadHandler):
    def get(self):
        if not get_user_email(): #stops from creating a profile if not logged in
            self.redirect("/")
            return
        id = self.request.get("id")
        is_admin = 0
        if users.is_current_user_admin():
            is_admin = 1
        if id is not None:
            q = models.check_if_user_exists(id)
            if q == None:
                page_params = {
                    'upload_url': blobstore.create_upload_url('/profile'),
                    'user_email': get_user_email(),
                    'login_url': users.create_login_url(),
                    'logout_url': users.create_logout_url('/'),
                    'user_id': get_user_id(),
                    'profile': models.getUser(id),
                    'admin': is_admin
                }
                render_template(self, 'createProfile.html' ,page_params)
                return
        user = models.getUser(id)

        categoryScores = models.getCatUserScore(get_user_id())
        page_params = {
            'upload_url': blobstore.create_upload_url('/profile'),
            'user_email': get_user_email(),
            'login_url': users.create_login_url(),
            'logout_url': users.create_logout_url('/'),
            'user_id': get_user_id(),
            'profile': user,
            'numScores': len(categoryScores),
            'categoryScores':categoryScores,
            'admin': is_admin,
        }
        render_template(self, 'profile.html', page_params)

    def post(self):
        #will need to be moved to occur after form submission
        id = get_user_id()
        user = models.getUser(id)
        if user is None:
            models.createUser(id)
            user = models.getUser(id)
        try:
            upload_files = self.get_uploads()
            blob_info = upload_files[0]
            type = blob_info.content_type
            models.createUser(id)
            name = self.request.get("name")
            year = self.request.get("year")
            interests = self.request.get("interests")
            employer = self.request.get("employer")
            bio = self.request.get("bio")
            username= self.request.get('username')
            id = get_user_id()
            if username == "":
                username = user.username
            # if the uploaded file is an image
            if type in ['image/jpeg', 'image/png', 'image/gif', 'image/webp']:
                image = blob_info.key()
                models.updateUser(id, name, year, interests, bio, employer,username, image)

            # if the uploaded file is not an image
            else:
                models.updateUser(id, name, year, interests, bio,
                        employer,username, user.image_url)

            self.redirect('/profile?id=' + id)
        # no image to upload
        except IndexError:
            id = get_user_id()
            models.createUser(id)
            name = self.request.get("name")
            year = self.request.get("year")
            interests = self.request.get("interests")
            employer = self.request.get("employer")
            bio = self.request.get("bio")
            username = self.request.get('username')
            if username == "":
                username = user.username
            id = get_user_id()
            models.updateUser(id, name, year, interests, bio,
                    employer,username, user.image_url)
            self.redirect('/profile?id=' + id)

class ImageHandler(blobstore_handlers.BlobstoreDownloadHandler):
  def get(self):
    id = self.request.get("id")
    profile = models.getUser(id)
    try:
     image = images.Image(blob_key=profile.image_url)
     self.send_blob(profile.image_url)
    except Exception:
     pass

class ImageHandlerQuestion(blobstore_handlers.BlobstoreDownloadHandler):
  def get(self):
    urlkey = self.request.get('urlkey')
    review = models.getQuestionFromURL(urlkey)
    try:
     image = images.Image(blob_key=review.image_urlQ)
     self.send_blob(review.image_urlQ)
    except Exception:
     pass

#Processes the AJAX post for updating of the answer selected by the user in a quiz
class answerSingle(webapp2.RequestHandler):
    def post(self):
        self.response.headers.add_header('Access-Control-Allow-Origin', '*')
        self.response.headers['Content-Type'] = 'application/json'
        data = json.loads(self.request.body)

        question = models.getQuestionFromURL(data['qKey'])
        models.createAnswer(data['userID'],question.key,str(data['userSelection']), int(data['score']))

def obj_dict(obj):
    return obj.__dict__

#Fetches the quiz and passes the relevenat material pertaining to the questions with it.
class categoryQuiz(webapp2.RequestHandler):
    def get(self):
        id = get_user_id()
        is_admin = 0
        if users.is_current_user_admin():
            is_admin = 1
        if id is not None:
            q = models.check_if_user_exists(id)
            if q == None:
                page_params = {
                    'upload_url': blobstore.create_upload_url('/profile'),
                    'user_email': get_user_email(),
                    'login_url': users.create_login_url(),
                    'logout_url': users.create_logout_url('/'),
                    'user_id': get_user_id(),
                    'profile': models.getUser(id),
                    'admin': is_admin
                }
                render_template(self, 'createProfile.html' ,page_params)
                return
        category = self.request.get('category')
        number = self.request.get('number')
        questions = models.getQuestionsCat(category,int(number))
        if questions is None:
            num = 0
            jList = []
        else:
            num = len(questions)
            qList = []
            for q in questions:
                #exclude removes the properties we do no need to have passed to the html from the question object
                temp = q.to_dict(exclude=['category','creator','accepted','up_voters','down_voters','create_date'])
                qList.append(temp)
            jList = json.dumps(qList, default=obj_dict)

        page_params = {
            'user_id': get_user_id(),
            'num': num,
            'question_list' : jList,
            'user_email': get_user_email(),
            'login_url': users.create_login_url(),
            'logout_url': users.create_logout_url('/'),
            'admin': is_admin,
            }
        render_template(self, 'answerQuestionsCat.html', page_params)

#used for reporting a question from the review question page
class reportHandler(webapp2.RequestHandler):
    def post(self):
        body = "Comment:\n" + self.request.get("comment")
        sender_address = get_user_email() #not sure if we want to do this
        question = self.request.get("id")
        body = body + "\n\nVisit the question here: aecs1980qg.appspot.com/ReviewQuestion?id=" + question
        subject = "A question has been reported"
        mail.send_mail(sender_address , "bogdanbg24@gmail.com" , subject, body)
        self.redirect("/ReviewNewQuestions")

#used for reporting a question in the quiz
class reportQuizHandler(webapp2.RequestHandler):
    def post(self):
        self.response.headers.add_header('Access-Control-Allow-Origin', '*')
        self.response.headers['Content-Type'] = 'application/json'
        data = json.loads(self.request.body)
        comment = data['comment']
        body = "Comment:\n" + comment
        sender_address = get_user_email() #not sure if we want to do this
        question = data['urlkey']
        body = body + "\n\nVisit the question here: aecs1980qg.appspot.com/ReviewQuestion?id=" + question
        subject = "A question has been reported"
        mail.send_mail(sender_address , "bogdanbg24@gmail.com" , subject, body)

#Grabs all of the users scores for all time and sends JSON object to html
class LeaderBoard(webapp2.RequestHandler):
    def get(self):
        id = get_user_id()
        jAson = models.getAllUserScores()
        userList = json.dumps(jAson)
        is_admin = 0
        if users.is_current_user_admin():
            is_admin = 1
        if id is not None:
            q = models.check_if_user_exists(id)
            if q == None:
                page_params = {
                    'upload_url': blobstore.create_upload_url('/profile'),
                    'user_email': get_user_email(),
                    'login_url': users.create_login_url(),
                    'logout_url': users.create_logout_url('/'),
                    'user_id': get_user_id(),
                    'profile': models.getUser(id),
                    'admin': is_admin
                }
                render_template(self, 'createProfile.html' ,page_params)
                return
        newList = models.getCategoryList()
        page_params = {
            'category': 'ALL',
            'catList': newList,
            'user_id': get_user_id(),
            'list': jAson,
            'user_email': get_user_email(),
            'login_url': users.create_login_url(),
            'logout_url': users.create_logout_url('/'),
            'admin': is_admin,
            }
        render_template(self, 'leaderboard.html', page_params)
        
#AJAX Handler for Leaderboard
#Updates the leaderboard when the dropdown boxes are changed
#Sends back JSON object with updated list of usernames and their scores
#in the current category. Returns all users who have a score
class getNewCatScores(webapp2.RequestHandler):
    def post(self):
        self.response.headers.add_header('Access-Control-Allow-Origin', '*')
        self.response.headers['Content-Type'] = 'application/json'
        data = json.loads(self.request.body)
        cat = data['category']
        time = data['time']
        days = 0
        if time == "All" or time == "Time":
            if (cat == 'ALL'):
                jAson = models.getAllUserScores()
            elif (len(cat) == 0) :
                cat = 'ALL'
                jAson = models.getAllUserScores()
            else:
                jAson = models.getAllUserScoresForCat(cat)
            userList = json.dumps(jAson)
            self.response.out.write(userList)
            return
        logging.warning(time)
        if time == "Past Week":
            days = 7
        if time == "Past Month":
            days = 365
        if time == "Past Year":
            days = 30
        logging.warning(days)
        if (cat == 'ALL'):
            jAson = models.getAllUserScores(days)
        elif (len(cat) == 0) :
            cat = 'ALL'
            jAson = models.getAllUserScores(days)
        else:
            jAson = models.getAllUserScoresForCat(cat,days)
        userList = json.dumps(jAson)
        self.response.out.write(userList)

class reviewCategoryTable(webapp2.RequestHandler):
    def get(self):
        id = get_user_id()
        trueList = models.getCategoryList(True)
        falseList = models.getCategoryList(False)
        is_admin = 0
        if users.is_current_user_admin():
            is_admin = 1
        if id is not None:
            q = models.check_if_user_exists(id)
            if q == None:
                page_params = {
                    'upload_url': blobstore.create_upload_url('/profile'),
                    'user_email': get_user_email(),
                    'login_url': users.create_login_url(),
                    'logout_url': users.create_logout_url('/'),
                    'user_id': get_user_id(),
                    'profile': models.getUser(id),
                    'admin': is_admin
                }
                render_template(self, 'createProfile.html' ,page_params)
                return
        page_params = {
            'user_id': get_user_id(),
            'trueCatList': trueList,
            'falseCatList': falseList,
            'user_email': get_user_email(),
            'login_url': users.create_login_url(),
            'logout_url': users.create_logout_url('/'),
            'admin': is_admin,
            }
        render_template(self, 'reviewCategories.html', page_params)

class addNewCategory(webapp2.RequestHandler):
    def post(self):
        cat = self.request.get("cat")
        logging.warning(cat)
        models.changeCategoryStatus(cat,True)
        time.sleep(.1)
        self.redirect("/reviewCategories")

class removeNewCategory(webapp2.RequestHandler):
    def post(self):
        cat = self.request.get("cat")
        logging.warning(cat)
        models.changeCategoryStatus(cat,False)
        time.sleep(.1)
        self.redirect("/reviewCategories")

class deleteCategory(webapp2.RequestHandler):
    def post(self):
        cat = self.request.get("cat")
        logging.warning(cat)
        models.deleteCategoryPerm(cat)
        time.sleep(.1)
        self.redirect("/reviewCategories")

#Upvoting a question
class addVote(webapp2.RequestHandler):
    def post(self):
        id = self.request.get("id")
        email = get_user_email()
        models.addVote(id,email)
        self.redirect("/ReviewNewQuestions") #maybe want a confirmation page

#Downvoting a question
class decVote(webapp2.RequestHandler):
    def post(self):
        id = self.request.get("id")
        email = get_user_email()
        models.decVote(id,email)
        self.redirect("/ReviewNewQuestions")

#Upvoting a question
class addVoteQuiz(webapp2.RequestHandler):
    def post(self):
        self.response.headers.add_header('Access-Control-Allow-Origin', '*')
        self.response.headers['Content-Type'] = 'application/json'
        data = json.loads(self.request.body)
        id = data['urlkey']
        email = get_user_email()
        result = {}
        temp = models.addVote(id,email)
        result['incced'] = temp
        self.response.out.write(json.dumps(result))

#Downvoting a question
class decVoteQuiz(webapp2.RequestHandler):
    def post(self):
        self.response.headers.add_header('Access-Control-Allow-Origin', '*')
        self.response.headers['Content-Type'] = 'application/json'
        data = json.loads(self.request.body)
        id = data['urlkey']
        email = get_user_email()
        temp = models.decVote(id,email)
        result = {}
        result['decced'] = temp
        self.response.out.write(json.dumps(result))

class deleteQuestion(webapp2.RequestHandler):
    def post(self):
        self.response.headers.add_header('Access-Control-Allow-Origin', '*')
        self.response.headers['Content-Type'] = 'application/json'
        data = json.loads(self.request.body)
        key = data['urlkey']
        models.delete_question(key)
        #need this for some reason, for redirect in javascript to work
        self.redirect("/ReviewOldQuestions")

class checkUsername(webapp2.RequestHandler):
    def post(self):
        self.response.headers.add_header('Access-Control-Allow-Origin', '*')
        self.response.headers['Content-Type'] = 'application/json'
        data = json.loads(self.request.body)
        result= {}
        result['exists'] = models.checkUsername(data['username'])
        self.response.out.write(json.dumps(result))

class addCategory(webapp2.RequestHandler):
    def post(self):
        self.response.headers.add_header('Access-Control-Allow-Origin', '*')
        self.response.headers['Content-Type'] = 'application/json'
        data = json.loads(self.request.body)
        result= {}
        exists = models.checkCategory(data['category'])
        if not exists:
            models.createCategory(data['category'])
        result['exists'] = exists
        self.response.out.write(json.dumps(result))

###############################################################################
mappings = [
  ('/', MainPageHandler),
  ('/profile', ProfileHandler),
  ('/submitNew', SubmitPageHandler),
  ('/NewQuestion', NewQuestion),
  ('/ReviewQuestion', ReviewSingleQuestion),
  ('/deleteQuestion', deleteQuestion),
  ('/meanstackakalamestack', Setup),
  ('/ReviewNewQuestions', ReviewNewQuestions),
  ('/ReviewOldQuestions', ReviewOldQuestions),
  ('/answerSingle',answerSingle),
  ('/report', reportHandler),
  ('/reportQuiz', reportQuizHandler),
  ('/incrementVote' , addVote),
  ('/decrementVote', decVote),
  ('/addVoteQuiz', addVoteQuiz),
  ('/decVoteQuiz', decVoteQuiz),
  ('/image', ImageHandler),
  ('/imageQ', ImageHandlerQuestion),
  ('/takeQuiz', categoryQuiz),
  ('/firstLogin', LoginPageHandler),
  ('/leaderboard', LeaderBoard),
  ('/checkUsername', checkUsername),
  ('/getNewCatScores', getNewCatScores),
  ('/addCategory', addCategory),
  ('/reviewCategories', reviewCategoryTable),
  ('/addNewCategory', addNewCategory),
  ('/removeNewCategory', removeNewCategory),
  ('/deleteCategory', deleteCategory)
]
app = webapp2.WSGIApplication(mappings, debug=True)
