extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 100.0
@export var death_component: DeathComponent
@export var animation_player: AnimationPlayer

var health: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH
	pass # Replace with function body.

func damage(number: float):
	health -= number
	if animation_player != null:
		if animation_player.has_animation("damage"):
			animation_player.play("damage")
	if health <= 0:
		if death_component != null:
			death_component.die()
	
