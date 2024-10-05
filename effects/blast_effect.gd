extends AnimatedSprite2D



var markerPosition : Vector2


func _ready():
	position = markerPosition

func _process(delta):
	pass


func _on_animation_finished():
	queue_free()
