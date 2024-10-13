extends Label
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var seconds_left = int(timer.time_left)
	text = str(seconds_left)
	pass


func _on_timer_timeout() -> void:
	get_parent().end_game()
	pass # Replace with function body.
