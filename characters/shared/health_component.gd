extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 100.0
@export var death_component: DeathComponent
@export var animation_player: AnimationPlayer
@export var score_component: ScoreComponent

var health: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH
	pass # Replace with function body.

func damage(number: float):
	health -= number
	if score_component != null:
		score_component.took_damage(number)
	if health <= 0:
		if death_component != null:
			death_component.die()
			return
	if animation_player != null:
		if animation_player.has_animation("damage"):
			animation_player.play("damage")
	
