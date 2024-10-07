extends Node2D
const SETTINGS = preload("res://global/settings.tscn")
@onready var settings_button: Button = $SettingsButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_button.pressed.connect(_settings_button_pressed)
	pass # Replace with function body.

func _settings_button_pressed():
	var settings_scene = SETTINGS.instantiate()
	add_child(settings_scene)
