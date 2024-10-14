extends Control
@onready var back_button: Button = $CenterContainer/Panel/BackButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	back_button.pressed.connect(_back_button_pressed)

func _back_button_pressed():
	get_tree().paused = false
	queue_free()
