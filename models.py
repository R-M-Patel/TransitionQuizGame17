import json
import random
import logging
import os
import webapp2
import datetime
from datetime import date
import time
from operator import itemgetter
from collections import OrderedDict
from random import shuffle
from google.appengine.ext.webapp import template
from google.appengine.api import users
from google.appengine.ext import ndb
from google.appengine.api import memcache

#MODELS
###############################################################################
class User(ndb.Model):
    user_id = ndb.StringProperty()
    username = ndb.StringProperty(default = "No Username")
    name = ndb.StringProperty(default = "No Name")
    year = ndb.StringProperty(default = "No Year")
    interests = ndb.StringProperty(default = "No Interests")
    employer = ndb.StringProperty(default="University of Pittsburgh")
    bio = ndb.StringProperty(default = "No Bio")
    image_url = ndb.BlobKeyProperty()

#Created upon every answer in a quiz
#Child of User that answers the Question
class Answer(ndb.Model):
    questionKey = ndb.KeyProperty()
    chosenAnswer = ndb.StringProperty()
    category = ndb.KeyProperty()
    create_datetime = ndb.DateTimeProperty(auto_now_add = True)
    correct = ndb.BooleanProperty()

class Question(ndb.Model):
    category = ndb.KeyProperty()
    categoryText = ndb.StringProperty()
    question = ndb.StringProperty()
    answer1 = ndb.StringProperty()
    answer2 = ndb.StringProperty()
    answer3 = ndb.StringProperty()
    answer4 = ndb.StringProperty()
    answerid = ndb.StringProperty()
    creator = ndb.StringProperty(default="user")
    correctAnswers = ndb.IntegerProperty(default=0)
    incorrectAnswers = ndb.IntegerProperty(default=0)
    answer1Selections = ndb.IntegerProperty(default=0)
    answer2Selections = ndb.IntegerProperty(default=0)
    answer3Selections = ndb.IntegerProperty(default=0)
    answer4Selections = ndb.IntegerProperty(default=0)
    totalAnswers = ndb.IntegerProperty(default=0)
    explanation = ndb.StringProperty()
    create_date = ndb.DateProperty(auto_now_add=True)
    accepted = ndb.BooleanProperty(default=False)
    up_voters = ndb.StringProperty(repeated=True)
    down_voters = ndb.StringProperty(repeated=True)
    up_votes = ndb.IntegerProperty(default = 0)
    down_votes = ndb.IntegerProperty(default = 0)
    rating = ndb.ComputedProperty(lambda self:  self.up_votes - self.down_votes)
    score = ndb.IntegerProperty(default=0)
    image_urlQ = ndb.BlobKeyProperty()
    urlkey = ndb.StringProperty()
    deleted = ndb.BooleanProperty(default=False)

#One Score create per day per User per Category
#allows leaderboard resolution down to the day
class Score(ndb.Model):
    category = ndb.KeyProperty()
    categoryText = ndb.StringProperty()
    score = ndb.IntegerProperty()
    date = ndb.DateProperty(auto_now_add = True)

#currently not linked to Questions or Scores, just for listing on menus
#potentially room for optimization
class Category(ndb.Model):
    category = ndb.StringProperty()
    accepted = ndb.BooleanProperty(default = False)

#CREATORS
###############################################################################
#id is generated in main via Google's User class
#DIFFERENT FROM GOOGLES USER
def createUser(id):
    user = User()
    user.user_id = id
    user.key = ndb.Key(User,id)
    user.put()

def createCategory(categoryIn, acceptedIn=False):
    cat = Category()
    cat.category = categoryIn
    cat.accepted = acceptedIn
    cat.key = ndb.Key(Category, categoryIn)
    cat.put()


#adds an Answer object to the Datastore, as a child of User 'userid'
#updates Question with statistics
#updates Score object per category
def createAnswer(userid, questionKey, chosenAnswer, points = 0):
    answer = Answer(parent=ndb.Key(User, userid))
    question = getQuestion(questionKey)

    scoreList = Score.query(Score.category == question.category, Score.date ==
            date.today(), ancestor = ndb.Key(User, userid)).fetch(1)

    answer.questionKey = questionKey
    answer.chosenAnswer = chosenAnswer
    answer.category = question.category

    correctFlag = False

    rightAnswer = question.answerid
    if int(chosenAnswer) == int(rightAnswer):
        question.correctAnswers += 1
        answer.correct = True
        correctFlag = True
    else:
        question.incorrectAnswers += 1
        answer.correct = False
        correctFlag = False

    if len(scoreList) == 0: #Score hasn't been created
        if correctFlag == True:
            logging.warning("creating score" + str(question.category))
            createScore(userid, question.category, points)
        else:
            createScore(userid, question.category, 0)
    else: #Score exists

        if correctFlag:
            updateScore(userid, question.category, points)

    question.totalAnswers += 1

    if chosenAnswer == '1':
        question.answer1Selections += 1
    elif chosenAnswer == '2':
        question.answer2Selections += 1
    elif chosenAnswer == '3':
        question.answer3Selections += 1
    elif chosenAnswer == '4':
        question.answer4Selections += 1
    else:
        logging.critical("Answer isn't 1, 2, 3, or 4")


    question.put()
    answer.put()


def createScore(userid, category, points):
    scoreObj = Score(parent=ndb.Key(User, userid))
    scoreObj.category = category
    scoreObj.categoryText = category.get().category
    scoreObj.score = points
    scoreObj.put()


#creates and stores question in database
def createQuestion(category,question,answer1,answer2,answer3,answer4,answerid,explanation,creator,valid,image_urlQ = None):
    catKey = ndb.Key(Category, category)
    question = Question(
        category = catKey,
        categoryText = catKey.get().category,
        question=question,
        answer1=answer1,
        answer2=answer2,
        answer3=answer3,
        answer4=answer4,
        answerid=answerid,
        explanation=explanation,
        creator=creator,
        accepted=valid,
        image_urlQ=image_urlQ)
    question.put()
    question.urlkey = question.key.urlsafe()
    question.put()
    return question.key



#MODIFIERS
###############################################################################
def updateUser(id, name, year, interests, bio, employer,username, image_url = None):
    user = ndb.Key(User, id).get()
    user.name = name
    user.year = year
    user.interests = interests
    user.bio = bio
    user.employer = employer
    user.username = username
    user.image_url = image_url
    user.put()

def updateQuestion(urlkey,category,questionIn,answer1,answer2,answer3,answer4,answerid,explanation,creator,valid,image_urlQ = None):
    questKey=ndb.Key(urlsafe=urlkey)
    question = questKey.get()
    question.category=category
    question.question=questionIn
    question.answer1=answer1
    question.answer2=answer2
    question.answer3=answer3
    question.answer4=answer4
    question.answerid=answerid
    question.explanation=explanation
    question.creator=creator
    question.accepted=valid
    question.image_urlQ=image_urlQ
    question.put()

def updateScore(userid, category, points):
    scoreList = Score.query(Score.category == category, ancestor = ndb.Key(User,
        userid)).fetch(1)
    scoreObj = scoreList[0]
    scoreObj.score = scoreObj.score + points
    scoreObj.put()

#increments the vote counter
def addVote(id,email):
    question = getQuestionFromURL(id)

    if not check_if_up_voted(question.up_voters, email):
        question.up_voters.append(email)
        question.up_votes+=1
        if check_if_down_voted(question.down_voters, email):
            question.down_voters.remove(email)
            question.down_votes-=1
            question.put()
            return 2
        question.put()
        return 1
    return 0

#decrements the vote counter
def decVote(id,email):
    question = getQuestionFromURL(id)

    if not check_if_down_voted(question.down_voters, email):
        question.down_voters.append(email)
        question.down_votes+=1
        if check_if_up_voted(question.up_voters, email):
            question.up_voters.remove(email)
            question.up_votes-=1
            question.put()
            return 2
        question.put()
        return 1
    return 0

def delete_question_perm(key):
    return key.delete()

def delete_question(key):
    question =  getQuestionFromURL(key)
    question.deleted = True
    question.put()
    return

def changeCategoryStatus(category, statusIn):
    cat = ndb.Key(Category, category).get()
    cat.accepted = statusIn
    cat.put()

def deleteCategoryPerm(category):
    return ndb.Key(Category, category).delete()

#GETTERS
###############################################################################
def check_if_user_exists(id):
    result = list()
    q = ndb.Key(User, id).get()
    return q

def checkCategory(category):
    list = Category.query()
    for x in list:
        if x.category.strip().lower() == category.strip().lower():
            return True
    return False

#returns an iterable query object that has all answers of userid
def get_user_answers(userKey):
    answers = Answer.query(ancestor=ndb.Key(User, userKey)).fetch()
    return answers

#returns an iterable query object that has all answers of category
def get_category_answers(inCategory):
    answers = Answer.query(Answer.category == inCategory)
    return answers

def getUser(id):
    key = ndb.Key(User, id)
    return key.get()

def get_image(image_id):
  return ndb.Key(urlsafe=image_id).get()

def getQuestion(key):
    ac_obj = key.get()
    return ac_obj

def getQuestionFromURL(key):
    key = ndb.Key(urlsafe=key)
    return key.get()

#returns list of [number] Questions in [category]
def getQuestionsCat(category,number):
    q = Question.query(Question.category == ndb.Key(Category, category), Question.accepted ==
            True).fetch()
    if len(q) == 0:
        logging.critical("There aren't any questions. Have you populated the database?")
        return None
    shuffle(q)
    results = list()
    if len(q) >= number:
        for i in range(0,number):
            results.append(q[i])
    else:
        for item in q:
            results.append(item)
    return results

def check_if_up_voted(has_up_voted,email):
    if email in has_up_voted:
        return True
    return False

def check_if_down_voted(has_down_voted, email):
    if email in has_down_voted:
        return True
    return False

#checks if username is taken already
def checkUsername(username):
    qry = User.query()
    usernames = qry.fetch(projection=[User.username])
    for x in usernames:
        if x.username == username:
            return True
    return False

#return: (list) of questions, oldest first
def get_oldest_questions(val,deleted):
    query= Question.query(Question.accepted == val, Question.deleted == deleted)
    query.order(Question.create_date)
    return query.fetch()

#returns JSON list of unique categories
#defaults to only accepted questions
def getCategoryList(accepted = True):
    query = Category.query(Category.accepted == accepted)
    catList = []
    list = query.fetch()
    for item in list:
        temp = item.to_dict(include=['category'])
        catList.append(temp)
    jsonList = json.dumps(catList, default = obj_dict)
    return jsonList

def getAllCategories():
    query = Category.query()
    catList = []
    list = query.fetch()
    for item in list:
        temp = item.to_dict(include=['category'])
        catList.append(temp)
    jsonList = json.dumps(catList, default = obj_dict)
    return jsonList


#returns JSON list of {category, score} for a given user
#used in profile graph
def getCatUserScore(userid):
    user = getUser(userid)
    scores = Score.query(ancestor = ndb.Key(User, userid))
    scoreList = []
    for score in scores:
        temp = score.to_dict(include=['categoryText', 'score'])
        scoreList.append(temp)
    jsonList = json.dumps(scoreList, default = obj_dict)
    return jsonList

#returns JSON list of each User's total score, sorted largest to smallest
#defaults to all time
def getAllUserScores(timePeriod = 0):
    users = User.query()
    scoreList = dict()
    all = False
    if(timePeriod == 0):
        all = True
    for user in users:
        if all:
            scores = Score.query(ancestor = ndb.Key(User, user.user_id))
        else:
            scores = Score.query(Score.date >= date.today() - datetime.timedelta(timePeriod), ancestor = ndb.Key(User,user.user_id))
        counter = 0
        for score in scores:
            counter += score.score
        scoreList[user.username] = counter

    sortList = sorted(scoreList.items(), key=itemgetter(1), reverse=True)
    for x in sortList:
        scoreList = OrderedDict(sortList)
    jsonList = json.dumps(scoreList, default = obj_dict)
    return jsonList

#returns JSON list of every User's scores for category
#defaults to all time
def getAllUserScoresForCat(category, timePeriod = 0):
    category = ndb.Key(Category, category)
    users = User.query()
    scoreList = dict()
    all = False
    if(timePeriod == 0):
        all = True
    for user in users:
        if all:
            scores = Score.query(Score.category == category, ancestor = ndb.Key(User, user.user_id))
        else:
            scores = Score.query(Score.date >= date.today() - datetime.timedelta(timePeriod), Score.category == category, ancestor = ndb.Key(User, user.user_id))
        counter = 0
        for score in scores:
            counter += score.score
        scoreList[user.username] = counter

    sortList = sorted(scoreList.items(), key=itemgetter(1), reverse=True)
    scoreList = OrderedDict(sortList)
    jsonList = json.dumps(scoreList, default = obj_dict)
    return jsonList





#UTILITY
###############################################################################

#fills database with Questions from questions.txt
def populateQuestions():
    txt = open('questions.txt')
    list = []

    for line in txt:
        list.append(line.rstrip())

    createCategory("PHARM 2001", True)
    for x in range(0,60,6):
            question = list[x]
            answer1 = list[x+1]
            answer2 = list[x+2]
            answer3 = list[x+3]
            answer4 = list[x+4]
            answerid = list[x+5]
            createQuestion("PHARM 2001", question, answer1, answer2, answer3,
            answer4, answerid,"None","Stephen Curry",True)
    createCategory("PHARM 3023", True)
    for x in range(60,120, 6):
            question = list[x]
            answer1 = list[x+1]
            answer2 = list[x+2]
            answer3 = list[x+3]
            answer4 = list[x+4]
            answerid = list[x+5]
            createQuestion("PHARM 3023", question, answer1, answer2, answer3,
            answer4, answerid,"None","Stephen Curry",True)

    createCategory("PHARM 3028", True)
    for x in range(120,180, 6):
            question = list[x]
            answer1 = list[x+1]
            answer2 = list[x+2]
            answer3 = list[x+3]
            answer4 = list[x+4]
            answerid = list[x+5]
            createQuestion("PHARM 3028", question, answer1, answer2, answer3,
            answer4, answerid,"None","Stephen Curry",True)
    createCategory("PHARM 3040", True)
    for x in range(180,240, 6):
            question = list[x]
            answer1 = list[x+1]
            answer2 = list[x+2]
            answer3 = list[x+3]
            answer4 = list[x+4]
            answerid = list[x+5]
            createQuestion("PHARM 3040", question, answer1, answer2, answer3,
            answer4, answerid,"None","Stephen Curry",True)
    createCategory("PHARM 5218", True)
    for x in range(240,300, 6):
            question = list[x]
            answer1 = list[x+1]
            answer2 = list[x+2]
            answer3 = list[x+3]
            answer4 = list[x+4]
            answerid = list[x+5]
            createQuestion("PHARM 5218", question, answer1, answer2, answer3,
            answer4, answerid,"None","Stephen Curry",True)

    #non-approved category for testing
    createCategory("PHARM 6")

#creates one Answer per Question per User
def populateAnswers():
    users = User.query().fetch(10)
    for user in users:
        questions = Question.query()
        for question in questions:
            createAnswer(user.user_id, question.key, str(random.randint(1,4)), 10)


def obj_dict(obj):
    return obj.__dict__
