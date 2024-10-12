extends Node

@export var score_ui: Label

var current_score = 0
var current_combo = 0
var current_bonus = 0
var oneshot_combo_count = 0  # Track consecutive one-shots
var multiple_kill_timer = Timer.new()

# Track active popups globally
var active_popups = []  # For score popups
var active_special_popups = []  # For special popups (Combo, Oneshot)

const COMBO_TIME_WINDOW = 0.2
const BONUS_MULTIPLIER = 0.2
const NEARBY_POPUP_DISTANCE = 100  # Distance threshold for grouping popups

const SCORE_POP_UP = preload("res://characters/shared/score_pop_up.tscn")

func _ready() -> void:
	multiple_kill_timer.wait_time = COMBO_TIME_WINDOW
	multiple_kill_timer.one_shot = true
	multiple_kill_timer.timeout.connect(_on_combo_timeout)
	add_child(multiple_kill_timer)

# Call when an enemy is killed
func killed_enemy(worth_points: int, one_shot: bool, simultaneous: bool, pos: Vector2):
	var total_score = worth_points  # Start with the base points from the enemy

	if multiple_kill_timer.is_stopped():
		# First kill, no combo yet
		current_bonus = 0
		current_combo = 1
		oneshot_combo_count = 0  # Reset the oneshot combo count
		multiple_kill_timer.start()
	else:
		# More kills within the time window extend the combo
		current_combo += 1
		current_bonus += worth_points * BONUS_MULTIPLIER  # Apply combo bonus only for subsequent kills
		multiple_kill_timer.start()  # Restart the timer on each kill

	# Apply one-shot bonus if the enemy was one-shot
	if one_shot:
		current_bonus += worth_points * 0.5  # One-shot bonus
		oneshot_combo_count += 1  # Increment oneshot combo count for consecutive oneshots
	else:
		oneshot_combo_count = 0  # Reset oneshot combo count if no oneshot

	# If simultaneous kills, apply extra bonus (this is an optional logic)
	if simultaneous:
		current_bonus += worth_points * 1.0

	# Final score calculation
	if current_combo > 1 or one_shot:
		total_score += int(current_bonus)

	# Add the total score to the player's score
	_add_score(total_score)

	# Show the popup with the final score
	_show_popup(pos, total_score)

	# Show additional popups for special cases like combo and one-shot, but combine into one if nearby
	var special_texts = []
	if one_shot:
		special_texts.append("ONESHOT!")
	if current_combo > 1:
		special_texts.append("Combo %dX!" % current_combo)
	if special_texts.size() > 0:
		_show_combined_special_popup(pos, special_texts)

func _add_score(points: int):
	current_score += points
	if score_ui != null:
		score_ui.text = str(current_score)

# Combo ends when timer runs out
func _on_combo_timeout():
	current_combo = 0
	current_bonus = 0
	oneshot_combo_count = 0  # Reset oneshot combo when the timer runs out

# Move existing popups up when a new one appears
func _adjust_existing_popups():
	for popup in active_popups:
		popup.move_up()

# Show score pop-up at a position
func _show_popup(pos: Vector2, total_score: int):
	_adjust_existing_popups()  # Move existing popups up

	# Check if there's a nearby popup to group scores
	var nearby_popup = _find_nearby_popup(pos)
	if nearby_popup:
		# If a nearby popup exists, add points to it instead of creating a new one
		nearby_popup.add_points(total_score)
	else:
		# If no nearby popup, create a new one
		var popup = SCORE_POP_UP.instantiate()
		popup.start(pos, -1, 60, total_score)
		get_tree().root.add_child(popup)

		# Track the popup in the active popups list
		active_popups.append(popup)
		popup.popup_finished.connect(_on_popup_finished)

# Show combined special popups like "Combo X!" and "ONESHOT!"
func _show_combined_special_popup(pos: Vector2, special_texts: Array):
	_adjust_existing_popups()

	# Check if there's a nearby special popup to combine texts
	var nearby_special_popup = _find_nearby_special_popup(pos)
	var combined_text = "\n".join(special_texts)  # Combine texts, e.g., "Combo 2X! ONESHOT!"

	if nearby_special_popup:
		# If there's a nearby special popup, update its text
		nearby_special_popup.update_special_text(nearby_special_popup.text + "\n" + combined_text)
	else:
		# Create a new special popup if no nearby special popups are found
		var popup = SCORE_POP_UP.instantiate()
		popup.start(pos, -1, 60, 0, combined_text)
		get_tree().root.add_child(popup)

		# Track the special popup in the active special popups list
		active_special_popups.append(popup)
		popup.popup_finished.connect(_on_popup_finished)

# Find nearby score popup to group scores
func _find_nearby_popup(pos: Vector2) -> Node:
	for popup in active_popups:
		if popup.is_near(pos):
			return popup
	return null

# Find nearby special popup to combine special texts (Combo, Oneshot)
func _find_nearby_special_popup(pos: Vector2) -> Node:
	for popup in active_special_popups:
		if popup.is_near(pos):
			return popup
	return null

# Remove the popup from the active list when it finishes
func _on_popup_finished(popup):
	active_popups.erase(popup)
	if popup in active_special_popups:
		active_special_popups.erase(popup)
