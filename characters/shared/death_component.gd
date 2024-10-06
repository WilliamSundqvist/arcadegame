extends Node2D
class_name DeathComponent

@export var animation_player: AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func die():
	# Play cool animation
	if (animation_player != null):
		if animation_player.has_animation("death"):
			var death_timer = Timer.new()
			death_timer.wait_time = 1
			death_timer.timeout.connect(death_animation_end)
			add_child(death_timer)
			death_timer.start()
			animation_player.play("death")
		return
	get_parent().queue_free()
	pass

func death_animation_end():
	get_parent().queue_free()
	
