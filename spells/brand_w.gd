extends Area2D
@onready var cast_time: Timer = $CastTime
@onready var first_animation: AnimationPlayer = $FirstAnimation
@onready var flaming_pillar: CPUParticles2D = $FlamingPillar
@onready var duration: Timer = $Duration
@export var damage: int = 10

func _ready():
	first_animation.play()
	cast_time.start()
	duration.timeout.connect(duration_timeout)
	


func _on_first_animation_animation_finished(_anim_name: StringName) -> void:
	flaming_pillar.emitting = true
	duration.start()
	pass # Replace with function body.

func duration_timeout():
	queue_free()
