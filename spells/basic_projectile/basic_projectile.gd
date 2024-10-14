extends Area2D

@export var speed = 250

var dir : Vector2
var velocity = Vector2.ZERO
var markerPosition : Vector2
var targetPosition : Vector2
@export var damage: int = 30
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	position = markerPosition
	dir = (targetPosition - markerPosition).normalized()
	rotation_degrees = rad_to_deg(markerPosition.angle_to_point(targetPosition))
	audio_stream_player.play()
	
func _process(delta):
	velocity = dir * speed
	position += velocity * delta

func _on_area_entered(area):
	if area.has_method("damage"):
		area.damage(damage)
		hide()
		queue_free()
