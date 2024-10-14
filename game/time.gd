extends Label
@onready var timer: Timer = $Timer

var last_time_left = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var seconds_left = int(timer.time_left)
	if seconds_left == 40 && int(last_time_left) != 40:
		last_time_left = timer.time_left
		get_parent().decrease_spawn_timer()
	if seconds_left == 30 && int(last_time_left) != 30:
		last_time_left = timer.time_left
		get_parent().decrease_spawn_timer()
	if seconds_left == 10 && int(last_time_left) !=10:
		last_time_left = timer.time_left
		get_parent().decrease_spawn_timer()
	text = str(seconds_left)
	pass


func _on_timer_timeout() -> void:
	get_parent().end_game()
	pass # Replace with function body.
