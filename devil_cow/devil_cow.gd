extends Node2D

class_name DevilCow

@export var cow_speed: float = 150.0       # Speed when sprinting
@onready var player = $"../PlayerCharacter"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = 1
	input_vector.y = 0
	
	input_vector = (player.position - position).normalized()
	position += delta * cow_speed * input_vector
