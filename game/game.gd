extends Node2D
const SETTINGS = preload("res://global/settings.tscn")
@onready var settings_button: Button = $SettingsButton
@onready var cow = preload("res://characters/devil_cow/devil_cow.tscn")
var cowAlternator  = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_button.pressed.connect(_settings_button_pressed)
	pass # Replace with function body.

func _settings_button_pressed():
	var settings_scene = SETTINGS.instantiate()
	add_child(settings_scene)


func _on_cow_spawner_timeout():
	var cowEnemy = cow.instantiate()
	if(cowAlternator%2 == 0):
		cowEnemy.position = Vector2(randf_range(-20, 1000), -20)
	else:
		cowEnemy.position = Vector2(randf_range(-20, 1000), 1000)
	cowAlternator = !cowAlternator
	add_child(cowEnemy)
