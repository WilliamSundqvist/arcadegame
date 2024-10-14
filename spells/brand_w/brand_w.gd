extends Area2D
@onready var first_animation: AnimationPlayer = $FirstAnimation
@onready var flaming_pillar: CPUParticles2D = $FlamingPillar
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@export var damage: int = 20
@export var damage_interval: float = 0.2

func _ready():
	first_animation.play()	
	first_animation.animation_finished.connect(_on_first_animation_animation_finished)
	
func _on_first_animation_animation_finished(_anim_name: StringName) -> void:
	flaming_pillar.emitting = true
	audio_stream_player.play()
	damage_over_time_timeout()
	var damage_over_time_timer = Timer.new()
	add_child(damage_over_time_timer)
	damage_over_time_timer.wait_time = damage_interval
	damage_over_time_timer.timeout.connect(damage_over_time_timeout)
	damage_over_time_timer.autostart = true
	damage_over_time_timer.start()
	
	var duration_timer = Timer.new()
	add_child(duration_timer)
	duration_timer.wait_time = 1
	duration_timer.timeout.connect(duration_timeout)
	duration_timer.start()
	pass # Replace with function body.

func duration_timeout():
	queue_free()

func damage_over_time_timeout():
	# Get all overlapping bodies or areas inside the Area2D
	for area in get_overlapping_areas():
		# Check if the object has a 'damage' method, then apply damage
		if area.has_method("damage"):
			area.damage(damage)  # Call the damage method on the object
