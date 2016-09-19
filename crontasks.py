import webapp2
import models
from google.appengine.ext import ndb

class validate_questions(webapp2.RequestHandler):
    def get(self):
        #just loops and prints every question from query
        review = models.get_oldest_questions(False,False) #searches 1000 oldest invalid questions
        if review:
            for question in review:
                if question.rating > 1:
                    question.accepted = True
                    question.up_voters = []
                    question.down_voters = []
                    question.up_votes = 0
                    question.down_votes = 0
                    question.put()
                if question.rating < 1:
                    models.delete_question_perm(question.key)
        return

class delete_questions(webapp2.RequestHandler):
    def get(self):
        #just loops and prints every question from query
        review = models.get_oldest_questions(True,True) #searches 1000 oldest invalid questions
        if review:
            for question in review:
                models.delete_question_perm(question.key)
        return
        
mappings = [
  ('/tasks/validate_questions', validate_questions),
  ('/tasks/delete_questions', delete_questions),
]

app = webapp2.WSGIApplication(mappings, debug=True)