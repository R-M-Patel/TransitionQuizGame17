import webapp2
import logging
#from google.appengine.api import mail
from google.appengine.ext import ndb
from google.appengine.api import memcache

class delete_front_page_memcache(webapp2.RequestHandler):
	def get(self):
		memcache.delete("sort_by_votes")
		memcache.delete("featured")
		memcache.delete("recent_events")

mappings = [
  ('/tasks/delete_front_page_memcache', delete_front_page_memcache),
]

app = webapp2.WSGIApplication(mappings, debug=True)
