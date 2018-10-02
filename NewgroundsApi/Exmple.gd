extends Node2D

###!!!!!!!	READ BELOW!!!!!
###!!!!!!!	
###!!!!!!!	Be sure to open up the NewgroundApi.gd file to configure it to your game!!!!!!
###!!!!!!!	Also go to Project > Export >New HTML5 > Set ****BOTHxxxx Export templates to the NewGroundRelease.zip in the NewgroundAPI > ReleaseTemplate folder!!!!!!
###!!!!!!!	FYI, This will only work once uploaded to newgrounds due to cross-domain being disabled
###!!!!!!!	
###!!!!!!!	If you need any more help, contact me on the godot discord Duskitty#4455

func _ready():
	NewgroundApi.checkLogin()								#--Called when Checking for login (will auto open login window if no user immediately, optionally tie to a login button rather than in ready function)
	#NewgroundApi.requestLogin()							#--Used to open login window
	#NewgroundApi.cancelLogin()							#--Used to stop login window
	#NewgroundApi.logoutLogin()							#--Log player out from current session
	#NewgroundApi.unlockMedal("MedalName")			#--Unlock a Medal
	#NewgroundApi.postScore("Scoreboard", score)		#--Post A Score to scoreboard