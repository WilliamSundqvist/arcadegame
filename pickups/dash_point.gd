extends Node2D
@onready var player = $"../PlayerCharacter"

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		hide()
		player.availableDashes += 1
		queue_free()
