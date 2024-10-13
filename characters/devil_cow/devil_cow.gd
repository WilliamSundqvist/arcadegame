extends Node2D

class_name DevilCow

@export var cow_speed: float = 150.0       # Speed when sprinting
@onready var player = $"../PlayerCharacter"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_vector = Vector2.ZERO
	
	input_vector = (player.position - position).normalized()
	
	if input_vector.x < 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	position += delta * cow_speed * input_vector
