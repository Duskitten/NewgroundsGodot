extends Node

func _ready():
	var GameId = "-----" #Change me to your game ID, can be found at https://www.newgrounds.com/projects/games/your game ID/apitools/
	var GameBase64 = "-----" #Change me to your game Base64 Encryption Code, can be found at https://www.newgrounds.com/projects/games/your game ID/apitools/
	
	JavaScript.eval("""
/*
*
*
* Break To Login Code
*
*
*/
	loggedin = false
	ngio = new Newgrounds.io.core('"""+GameId+"""', '"""+GameBase64+"""');
	window.login = function() {};
	
	function onLoggedIn() {
	var welcome = "Welcome " + ngio.user.name + "!"
	console.log(welcome);
	loggedin = true
	};

	function onLoginFailed() {
	console.log("There was a problem logging in: " . ngio.login_error.message );
	}

	function onLoginCancelled() {
	console.log("The user cancelled the login.");
	}

	/*
	* Before we do anything, we need to get a valid Passport session.  If the player
	* has previously logged in and selected 'remember me', we may have a valid session
	* already saved locally.
	*/

	window.login.searchsession = function() {
		ngio.getValidSession(function() {
			if (ngio.user) {
				/*
				* If we have a saved session, and it has not expired,
				* we will also have a user object we can access.
				* We can go ahead and run our onLoggedIn handler here.
				*/
				onLoggedIn();
			} else {
				/*
				* If we didn't have a saved session, or it has expired
				* we should have been given a new one at this point.
				* This is where you would draw a 'sign in' button and
				* have it execute the following requestLogin function.
				*/
				window.login.requestLogin();
			};
		});
	};

	/*
	* Call this when the user clicks a 'sign in' button from your game.  It MUST be called from
	* a mouse-click event or pop-up blockers will prevent the Newgrounds Passport page from loading.
	*/

	window.login.requestLogin = function() {
	ngio.requestLogin(onLoggedIn, onLoginFailed, onLoginCancelled);
	/* you should also draw a 'cancel login' buton here */
	};

	/*
	* Call this when the user clicks a 'cancel login' button from your game.
	*/

	window.login.cancelLogin = function() {
	/*
	* This cancels the login request made in the previous function.
	* This will also trigger your onLoginCancelled callback.
	*/
	ngio.cancelLoginRequest();
	};

	/*
	* If your user is logged in, you should also draw a 'sign out' button for them
	* and have it call this.
	*/

	window.login.logOut = function() {
		ngio.logOut(function() {
		/*
		* Because we have to log the player out on the server, you will want
		* to handle any post-logout stuff in this function, wich fires after
		* the server has responded.
		*/
		});
	};

	window.login.loggedIn = function() {
		return loggedin
	};

	window.login.user = function() {
		if (ngio.user) {
			return ngio.user.name
		} else {
			var guest = "Guest"
			return guest
		};
	};


/*
*
*
* Break To Preload Medal-Scoreboard Code
*
*
*/
	window.medal = function() {};
	window.scoreboard = function() {};

	/* vars to record any medals and scoreboards that get loaded */
	var medals;
	var scoreboards;

	/* handle loaded medals */
	function onMedalsLoaded(result) {
		if (result.success) medals = result.medals;
	}

	/* handle loaded scores */
	function onScoreboardsLoaded(result) {
		if (result.success) scoreboards = result.scoreboards;
	}

	/* load our medals and scoreboards from the server */
	ngio.queueComponent("Medal.getList", {}, onMedalsLoaded);
	ngio.queueComponent("ScoreBoard.getBoards", {}, onScoreboardsLoaded);
	ngio.executeQueue();
/*
*
*
* Break To Medal Code
*
*
*/
	/* You could use this function to draw the medal notification on-screen */
	function onMedalUnlocked(medal) {
		console.log('MEDAL GET:', medal.name);
	}

	window.medal.unlock = function(medal_name) {
		/* If there is no user attached to our ngio object, it means the user isn't logged in and we can't unlock anything */
		if (!ngio.user) return;
		var medal;
		for (var i = 0; i < medals.length; i++) {
			medal = medals[i];
			/* look for a matching medal name */
			if (medal.name == medal_name) {
				/* we can skip unlocking a medal that's already been earned */
				if (!medal.unlocked) {
					/* unlock the medal from the server */
					ngio.callComponent('Medal.unlock', {id:medal.id}, function(result) {
						if (result.success) onMedalUnlocked(result.medal);
					});
				}
			return;
			}
		}
	};

/* lets unlock a medal!!! */
/*
*
*
* Break To Scoreboard Code
*
*
*/
	window.scoreboard.unlock = function(board_name, score_value) {
	/* If there is no user attached to our ngio object, it means the user isn't logged in and we can't post anything */
	if (!ngio.user) return;
	var score;
	for (var i = 0; i < scoreboards.length; i++) {
		scoreboard = scoreboards[i];
		ngio.callComponent('ScoreBoard.postScore', {id:scoreboard.id, value:score_value});
	}
	};

""", true)

func checkLogin():
	JavaScript.eval("""window.login.searchsession();""")
	yield(get_tree().create_timer(2), "timeout")
	var user = JavaScript.eval("""window.login.user();""")
	print(user)
	print("Welcome "+ str(user) +"!")

func requestLogin():
	JavaScript.eval("""window.login.requestLogin();""")

func cancelLogin():
	JavaScript.eval("""window.login.cancelLogin();""")

func logoutLogin():
	JavaScript.eval("""window.login.logOut();
	console.log("Logging Player Out!");""")

func unlockMedal(medalname):
	JavaScript.eval("window.medal.unlock('" + medalname + "');")

func postScore(scoreboard, score):
	JavaScript.eval(
	("window.scoreboard.unlock('"+ scoreboard +"', "+str(score)+");"))

