extends Node2D

# --- Constants and Variables ---
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var submit_highscore_button: Button = $CenterContainer/VBoxContainer/SubmitHighscoreButton
@onready var play_game_button: Button = $CenterContainer/VBoxContainer/PlayGameButton
@onready var leaderboard_button: Button = $CenterContainer/VBoxContainer/LeaderboardButton
@onready var score_container: VBoxContainer = $CenterContainer/VBoxContainer/ScrollContainer/ScoreContainer
@onready var login_button: Button = $CenterContainer/VBoxContainer/LoginButton

const APP_ID = "525f4753-8c75-4516-8b21-050d42f0c514"
const LEADERBOARD_ID = "b3a4adfd-ffe1-4c48-b259-6b88e4a30092"
const LEADERBOARD_KEY = "leaderboard_czZAnLDyzFWPAo-D3PyB64Pc2O8newKLl3MPcxQU3pDIxnyYg2ywlg4bqxRM6Gd5"
const GAME_SCENE_PATH = "res://game/game.tscn"
var token = ""
var user_id = ""
var oauth_url = "https://hyplay.com/oauth/authorize/?appId=525f4753-8c75-4516-8b21-050d42f0c514&chain=HYCHAIN_TESTNET&responseType=token&redirectUri="
var app_url = "http://localhost:8080/ArcadeGame.html"

# --- Initialization and Setup ---
func _ready() -> void:
	# Connect signals
	play_game_button.connect("pressed", _on_play_button_pressed)
	submit_highscore_button.connect("pressed", _on_submit_button_pressed)
	leaderboard_button.connect("pressed", _on_leaderboard_button_pressed)
	login_button.connect("pressed", _on_login_button_pressed)
	
	http_request.request_completed.connect(_on_request_completed)
	
	app_url = _get_current_url()
	token = _get_token_from_url() # Looks for auth token in the end of URL, will be empty on first load
	print("Access token: ", token)
	print("Test")
	# Set up button visibility based on token availability
	if token == "":
		login_button.visible = true
		leaderboard_button.visible = false
		submit_highscore_button.visible = false
		return
		
	login_button.visible = false
	leaderboard_button.visible = true
	submit_highscore_button.visible = true
	print("Access token found, fetching user ID...")
	_get_current_user_id(token)




func _get_current_url() -> String:
	var current_url = JavaScriptBridge.eval("window.location.href;")
	if !current_url:
		return ""
	print(current_url)
	return current_url

# --- Utility Functions ---
func _get_token_from_url() -> String:
	var token = JavaScriptBridge.eval("window.location.hash.substr(1);")
	if token == null or token == "":
		return ""
	var token_part = token.split("=")
	if token_part.size() > 1:
		return token_part[1]
	return ""

func _redirect_to_login() -> void:
	JavaScriptBridge.eval("window.top.location=\"" + oauth_url + app_url + "\";")
	#OS.shell_open(OAUTH_URL) apparently best way is to use js

# Hash with leaderboard key, user ID, and score for saving highscores
func generate_score_hash(leaderboard_key: String, user_id: String, score: int) -> String:
	var to_hash = leaderboard_key.strip_edges() + ":" + user_id.strip_edges() + ":" + str(score).strip_edges()
	print("String being hashed: ", to_hash)

	var hashing_context = HashingContext.new()
	hashing_context.start(HashingContext.HASH_SHA256)
	hashing_context.update(to_hash.to_utf8_buffer())
	var hash = hashing_context.finish()

	return hash.hex_encode()

# --- Core API Interaction Functions ---
func _get_current_user_id(token: String) -> void:
	var headers: PackedStringArray = [
		"x-session-authorization: " + token,
		"Content-Type: application/json"
	]

	var result = http_request.request("https://api.hyplay.com/v1/users/me", headers, HTTPClient.METHOD_GET)
	if result == OK:
		print("Fetching user info...")
	else:
		print("Failed to initiate user info request. Error code: ", result)

func _submit_score(token: String, user_id: String, score: int) -> void:
	print("Submitting score for user ID: ", user_id)

	var hash = generate_score_hash(LEADERBOARD_KEY, user_id, score)
	print("Generated hash: ", hash)

	var score_data = {
		"score": score,
		"hash": hash
	}

	var json_data = JSON.stringify(score_data)
	print("Score data JSON: ", json_data)

	var headers: PackedStringArray = [
		"x-session-authorization: " + token,
		"Content-Type: application/json"
	]

	var result = http_request.request("https://api.hyplay.com/v1/apps/" + APP_ID + "/leaderboards/" + LEADERBOARD_ID + "/scores", headers, HTTPClient.METHOD_POST, json_data)

	if result == OK:
		print("Score submission initiated...")
	else:
		print("Failed to initiate score submission. Error code: ", result)

func _get_leaderboard_scores(token: String, limit: int = 25, offset: int = 0) -> void:
	var headers: PackedStringArray = [
		"x-session-authorization: " + token,
		"Content-Type: application/json"
	]

	var query_params = "?limit=" + str(limit) + "&offset=" + str(offset)
	var url = "https://api.hyplay.com/v1/apps/" + APP_ID + "/leaderboards/" + LEADERBOARD_ID + "/scores" + query_params

	var result = http_request.request(url, headers, HTTPClient.METHOD_GET)

	if result == OK:
		print("Fetching leaderboard scores...")
	else:
		print("Failed to fetch leaderboard scores. Error code: ", result)

# --- Event Handlers ---
func _on_request_completed(result, response_code, headers, body):
	print("Request completed with code: ", response_code)
	print("Response body: ", body.get_string_from_utf8())

	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		print(json)
		if json.has("username"):
			# Handle user info request completion
			if json.has("id"):
				user_id = json["id"]
				print("User ID: ", user_id)
			# Handle score submission response (I think this one isnt working right now, we get error on score submission
			else:
				print("Score successfully submitted: ", json)
		elif json.has("scores"):
			#Handle leaderboard request completion
			print("Leaderboard scores: ")
			for score in json["scores"]:
				print("Username: ", score["username"], " - Score: ", score["score"])
				add_score(score["username"], score["score"])
		else:
			print("Error parsing JSON response: ", json)

	elif response_code == 400:
		print("Bad Request: Check the data being sent.")
	elif response_code == 401:
		print("Unauthorized: Invalid or expired session token.")
	else:
		print("Unexpected response code: ", response_code)

func _on_play_button_pressed() -> void:
	SceneManager.change_scene(GAME_SCENE_PATH)
		
# Replace this entire function in the future with a save_score function that should be called on gameover screen
func _on_submit_button_pressed() -> void:
	if user_id != "":
		_submit_score(token, user_id, 5) 
	else:
		print("User ID not available. Cannot submit score.")

func _on_leaderboard_button_pressed() -> void:
	# Clear leaderboard
	for child in score_container.get_children():
		score_container.remove_child(child)
	if token != "":
		_get_leaderboard_scores(token, 25, 0)  # Fetch top 25 scores
	else:
		print("Access token not available. Cannot fetch leaderboard.")

func _on_login_button_pressed() -> void:
	_redirect_to_login()

# --- Leaderboard UI Update ---
func add_score(username: String, score: float):
	var label = Label.new()
	label.text = username + "-" + str(score)
	score_container.add_child(label)
