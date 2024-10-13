extends Area2D
class_name HitboxComponent

@export var health_component: HealthComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func damage(number: float):
	if health_component:
		health_component.damage(number)

func disable_collision():
	collision_shape_2d.set_deferred("disabled", true)
