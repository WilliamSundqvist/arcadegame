extends State

@export var dashSpeed: float = 6000.0   # How fast the character accelerates

var mouse_position = null
var direction = null
var canDash = true
var dashing = false

func process(character: PlayerCharacter, delta):
	if canDash == true and character.availableDashes > 0:
		mouse_position = character.get_global_mouse_position()
		direction = (mouse_position - character.position).normalized()
		character.position += direction * dashSpeed * delta
		canDash = false
		dashing = true
		character.dashTimer.start()
		await character.dashTimer.timeout
		canDash = true
		dashing = false
		character.availableDashes = character.availableDashes - 1
		shoot(character, Vector2(0, 100))
		shoot(character, Vector2(0, -100))
		shoot(character, Vector2(100, 0))
		shoot(character, Vector2(-100, 0))
		if character.availableDashes == 0:
			character.dash_label.visible = false
	character.change_state(character.state_moving)

func shoot(character: PlayerCharacter, direction: Vector2):
	var level_root = character.get_parent().get_parent()
	var projectile = load("res://spells/basic_projectile/basicProjectile.tscn")
	var instance = projectile.instantiate()
	instance.global_position = character.global_position
	instance.targetPosition = character.global_position + direction
	instance.markerPosition = character.global_position
	level_root.add_child(instance)
