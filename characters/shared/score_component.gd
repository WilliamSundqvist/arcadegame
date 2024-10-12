extends Node2D
class_name ScoreComponent

@export var base_score = 100  # Base score of the enemy
@export var time = 0.2  # Time window for one-shot detection
const SCORE_POP_UP = preload("res://characters/shared/score_pop_up.tscn")

# New variables to handle popup positioning over time
var last_popup_time: float = 0.0
var popup_distance: float = 60.0  # Initial distance

var timer: Timer
var combo = 0
var one_shot = false
var first_damage_time = -1.0

func _ready():
	timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.timeout.connect(one_shot_timeout)
	add_child(timer)

# Enemy took damage, track whether it's a one-shot
func took_damage(damage: float):
	if first_damage_time == -1.0:
		first_damage_time = Time.get_ticks_msec() / 1000.0  # Mark the time of first damage

	if timer.is_stopped():
		timer.start()
		combo = 1
	else:
		combo += 1

	# Check if it's a one-shot based on the short damage window
	if Time.get_ticks_msec() / 1000.0 - first_damage_time < 0.3:
		one_shot = true

# Timer expired, no longer one-shot
func one_shot_timeout():
	combo = 0
	one_shot = false

# Called when this enemy dies
func death(simultaneous: bool = false):
	if ScoreManager != null:
		ScoreManager.killed_enemy(base_score, one_shot, simultaneous, global_position)

	queue_free()
