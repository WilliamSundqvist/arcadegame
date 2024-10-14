extends Area2D
class_name HitboxComponent

@export var health_component: HealthComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func damage(number: float):
	if health_component:
		health_component.damage(number)

func disable_collision():
	collision_shape_2d.set_deferred("disabled", true)


func game_over():
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			get_parent().get_parent().end_game()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var game_over_timer = Timer.new()
		game_over_timer.one_shot = true
		game_over_timer.wait_time = 0.1
		game_over_timer.timeout.connect(game_over)
		add_child(game_over_timer)
		game_over_timer.start()
