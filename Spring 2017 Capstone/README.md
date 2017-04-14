Here you will find working files for the migration of the quiz game to PHP server.

The file tree is set up assuming that the primary location the webserver will direct
to will be the public folder. This will keep the includes folder out of the public
eye. The includes folder will store our php scripts and functions.

To install and run on a local machine:  
	- You need WAMP/MAMP/LAMP for a local web server.  
	- Copy both the includes folder and public folder to the root directory of your local server  
	- navigate to localhost/public/index.php  

Login functionality, as well as basic quiz game functionality are implemented.  
To Do:  
- user registration page
- create question page
- review new questions page
- review flagged questions page
- review category page
- page for owners to manage accounts (create admins/ban users/etc)
- leaderboard
