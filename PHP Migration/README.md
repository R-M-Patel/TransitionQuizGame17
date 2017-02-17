Here you will find working files for the migration of the quiz game to PHP server.

The file tree is set up assuming that the primary location the webserver will direct
to will be the public folder. This will keep the includes folder out of the public
eye. The includes folder will store our php scripts and functions.

To install and run on a local machine:
	- You need WAMP/MAMP/LAMP for a local web server.
	- Copy both the includes folder and public folder to the root directory of your local server
	- navigate to localhost/public/index.php

Database connectivity is not yet set up. Also, the > play button does not bring you to the dropdowns yet.
You can change how the main site looks by changing the $username variable in index.php from a username 
to the empty string ("") and back. This will update the navigation links on the navbar just like on the live
site.

This should provide some proof of concept and a blueprint for moving forward with the project.
