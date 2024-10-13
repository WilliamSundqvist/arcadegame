extends Label

signal popup_finished  # Signal emitted when the popup finishes

@onready var timer: Timer = $Timer

# Variable to store the points in the popup
var points: int = 0

# The start function initializes the popup text, points, and position
func start(pos: Vector2, direction: int, distance: int = 60, initial_points: int = 100, optional_text: String = "") -> void:
	points = initial_points
	# Set text to optional_text if provided, otherwise display points
	if optional_text != "":
		text = optional_text
	else:
		text = "+%d" % points  # Set the label text based on points
	position = pos
	
	# Create a SceneTreeTween node and add it to the scene.
	var tween = create_tween()

	# Interpolate the position of the label from start to end.
	tween.tween_property(
		self,  # The node whose property we want to animate
		"position",  # The property to animate
		position,  # Starting position
		0
	)
	
	tween.tween_property(
		self,  # The node whose property we want to animate
		"position",  # The property to animate
		Vector2(pos.x, pos.y + distance * direction),  # Ending position
		0.6  # Duration of the animation
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	# Connect the tween completion to the _on_tween_completed method
	tween.finished.connect(self._on_tween_completed)

# Move the popup further up when a new popup appears
func move_up():
	var new_position = Vector2(position.x, position.y - 100)  # Move upwards by 100 pixels
	var tween = create_tween()
	tween.tween_property(
		self,
		"position",
		position,
		0
	)
	tween.tween_property(
		self,
		"position",
		new_position,
		0.6  # Duration of the movement
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

# This function will be called when the tween animation is complete
func _on_tween_completed():
	timer.start()  # Start the timer for cleanup

# When the timer expires, free the popup and emit a signal
func _on_timer_timeout() -> void:
	emit_signal("popup_finished", self)  # Notify the ScoreManager that this popup is done
	queue_free()  # Remove the popup from the scene

# Add points to the popup when a nearby enemy dies
func add_points(new_points: int) -> void:
	points += new_points  # Update the stored points value
	text = "+%d" % points  # Update the label text to reflect the new total points

# Method to update the popup for special cases like "ONESHOT!" or "Combo X!"
func update_special_text(new_text: String) -> void:
	text = new_text  # Update the popup text with the special text

# Check if this popup is near another position
func is_near(other_pos: Vector2) -> bool:
	return position.distance_to(other_pos) < 50  # Adjust the distance threshold as needed
