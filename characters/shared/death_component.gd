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
			animation_player.animation_finished.connect(animation_ended)
			animation_player.play("death")
		return
	get_parent().queue_free()
	pass

func animation_ended(animation_name: StringName):
	print(animation_name)
	if animation_name == "death":
		get_parent().queue_free()
	
