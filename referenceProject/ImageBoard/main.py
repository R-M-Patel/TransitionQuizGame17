import datetime
import logging
import os
import webapp2

from google.appengine.ext.webapp import template
from google.appengine.api import users
from google.appengine.ext import ndb
from google.appengine.api import images
from google.appengine.ext import blobstore
from google.appengine.ext.webapp import blobstore_handlers

###############################################################################
# We'll just use this convenience function to retrieve and render a template.
def render_template(handler, templatename, templatevalues={}):
  path = os.path.join(os.path.dirname(__file__), 'templates/' + templatename)
  html = template.render(path, templatevalues)
  handler.response.out.write(html)


###############################################################################
# We'll use this convenience function to retrieve the current user's email.
def get_user_email():
  result = None
  user = users.get_current_user()
  if user:
    result = user.email()
  return result


###############################################################################
class MainPageHandler(webapp2.RequestHandler):
  def get(self):
    images = get_images()
    email = get_user_email()
    if email:
      for image in images:
        image.voted = image.is_voted(email)

    page_params = {
      'images': images,
      'user_email': email,
      'login_url': users.create_login_url(),
      'logout_url': users.create_logout_url('/')
    }
    render_template(self, 'index.html', page_params)


###############################################################################
class DumbHandler(webapp2.RequestHandler):
  def get(self):
    email = get_user_email()
    if email:
      image_id = self.request.get('id')
      image = get_image(image_id)
      image.add_vote(email)
    self.redirect('/')


###############################################################################
class NotDumbHandler(webapp2.RequestHandler):
  def get(self):
    email = get_user_email()
    if email:
      image_id = self.request.get('id')
      image = get_image(image_id)
      image.remove_vote(email)
    self.redirect('/')


###############################################################################
class ImageDetailHandler(webapp2.RequestHandler):
  def get(self):
    id = self.request.get('id')
    image = get_image(id)
    email = get_user_email()
    if image:
      image.comments = image.get_comments()
      image.comment_count = len(image.comments)
      image.count = image.count_votes()
      page_params = {
        'user_email': email,
        'login_url': users.create_login_url(),
        'logout_url': users.create_logout_url('/'),
        'image': image
      }
      render_template(self, 'image.html', page_params)
    else:
      self.redirect('/')


###############################################################################
class CommentHandler(webapp2.RequestHandler):
  def post(self):
    email = get_user_email()
    if email: 
      image_id = self.request.get('image-id')
      image = get_image(image_id)
      if image:
        text = self.request.get('comment')
        image.create_comment(email, text)
        self.redirect('/image?id=' + image_id)
    else:
      self.redirect('/')

      
      
###############################################################################
class UploadPageHandler(webapp2.RequestHandler):
  def get(self):
    email = get_user_email()
    if email:
      upload_url = blobstore.create_upload_url('/upload_complete')
      page_params = {
        'user_email': email,
        'login_url': users.create_login_url(),
        'logout_url': users.create_logout_url('/'),
        'upload_url': upload_url
      }
      render_template(self, 'upload.html', page_params)
    else:
      self.redirect('/')


###############################################################################
class FileUploadHandler(blobstore_handlers.BlobstoreUploadHandler):
  def post(self):
    email = get_user_email()
    if email:
      upload_files = self.get_uploads()
      blob_info = upload_files[0]
      type = blob_info.content_type
      
      if type in ['image/jpeg', 'image/png', 'image/gif', 'image/webp']:      
        title = self.request.get('title')
        posted_image = PostedImage()
        posted_image.title = title
        posted_image.user = email
        posted_image.image_url = images.get_serving_url(blob_info.key())
        posted_image.put()
        self.redirect('/')


###############################################################################
class PostedImage(ndb.Model):
  title = ndb.StringProperty()
  image_url = ndb.StringProperty()
  user = ndb.StringProperty()
  time_created = ndb.DateTimeProperty(auto_now_add=True)

  def add_vote(self, user):
    ImageVote.get_or_insert(user, parent=self.key)
    
  def remove_vote(self, user):
    image_vote = ImageVote.get_by_id(user, parent=self.key)
    if image_vote:
      image_vote.key.delete()
    
  def count_votes(self):
    q = ImageVote.query(ancestor=self.key)
    return q.count()
    
  def is_voted(self, user):
    result = False
    if ImageVote.get_by_id(user, parent=self.key):
      result = True
    return result
    
  def create_comment(self, user, text):
    comment = ImageComment(parent=self.key)
    comment.user = user
    comment.text = text
    comment.put()
    return comment
    
  def get_comments(self):
    result = list()
    q = ImageComment.query(ancestor=self.key)
    q = q.order(-ImageComment.time_created)
    for comment in q.fetch(1000):
      result.append(comment)
    return result
    
  def count_comments(self):
    q = ImageComment.query(ancestor=self.key)
    return q.count()
    

###############################################################################
def get_images():
  result = list()
  q = PostedImage.query()
  q = q.order(-PostedImage.time_created)
  for img in q.fetch(100):
    img.count = img.count_votes()
    img.comment_count = img.count_comments()
    result.append(img)
  return result


###############################################################################
def get_image(image_id):
  return ndb.Key(urlsafe=image_id).get()
  
  
###############################################################################
class ImageComment(ndb.Model):
  user = ndb.StringProperty()
  text = ndb.TextProperty()
  time_created = ndb.DateTimeProperty(auto_now_add=True)  


###############################################################################
class ImageVote(ndb.Model):
  pass
  

###############################################################################
mappings = [
  ('/', MainPageHandler),
  ('/upload', UploadPageHandler),
  ('/upload_complete', FileUploadHandler),
  ('/dumb', DumbHandler),
  ('/notdumb', NotDumbHandler),
  ('/image', ImageDetailHandler),
  ('/comment', CommentHandler)
]
app = webapp2.WSGIApplication(mappings, debug=True)