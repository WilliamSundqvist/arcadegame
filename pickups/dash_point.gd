extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		hide()
		body.availableDashes += 1
		queue_free()
