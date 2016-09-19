import cgi
from google.appengine.api import users
import webapp2
import models

MAIN_PAGE_HTML = """\
<html>
  <head>
    <meta charset="UTF-8">
    <title>Add a Question</title>
        <link rel="stylesheet" href="/style.css">
  </head>
  <body>
<form action=/NewQuestion method="post"><font size = 4>
  Category:
  <input list="Category" name="category" method=POSTrequired>
  <datalist id="Category">
    <option value="PHARM 2001">
    <option value="PHARM 3023">
    <option value="PHARM 3028">
    <option value="PHARM 3040">
    <option value="PHARM 5218">
  </datalist>
</br>
  Question:
  <input type="text" size = "45" name="questiontext"method=POST required>
  <hr>
  <ol>
    <li class="red-text">
      <input type="text" method=POST name="answer1" required>
    </li>
    <li class="blue-text">
      <input type="text" method=POST name="answer2" required>
    </li>
    <li class="green-text">
      <input type="text" method=POST name="answer3" required>
    </li>
    <li class="yellow-text">
      <input type="text" method=POST name="answer4" required>
    </li>
  </ol>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type="submit" name="answerid" value="One" class="red-text">1</button>
    <input type="submit" name="answerid" value="Two" class="blue-text">2</button>
    <input type="submit" name="answerid" value="Three" class="green-text">3</button>
    <input type="submit" name="answerid" value="Four" class="yellow-text">4</button>
  </form>
</font>
</body>
</html>
"""

class MainPage(webapp2.RequestHandler):
    def get(self):
        self.response.write(MAIN_PAGE_HTML)

class NewQuestion(webapp2.RequestHandler):
    def post(self):
        category = self.request.get('category')
        question = self.request.get('questiontext')
        answer1 = self.request.get('answer1')
        answer2 = self.request.get('answer2')
        answer3 = self.request.get('answer3')
        answer4 = self.request.get('answer4')
        answerid = self.request.get('answerid')
        questionID = models.create_question(category,question,answer1,answer2,answer3,answer4,answerID)
        self.response.write('<html><body>You wrote:<pre>');
        self.response.write(category)
        self.response.write('</br>'+question)
        self.response.write('</br>'+answer1)
        self.response.write('</br>'+answer2)
        self.response.write('</br>'+answer3)
        self.response.write('</br>'+answer4)
        self.response.write('</br>The answer is: '+answerid)
        self.response.write('</pre></body></html>')

app = webapp2.WSGIApplication([
    ('/', MainPage),
    ('/NewQuestion', NewQuestion)
], debug=True)
