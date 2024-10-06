extends Marker2D
@onready var player = $"../.."
var mousePosition
var dir
var radius = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir = ( get_global_mouse_position() - player.position).normalized()
	position = dir * radius
