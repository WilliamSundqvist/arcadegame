extends State

@export var dashSpeed: float = 6000.0   # How fast the character accelerates

var mouse_position = null
var direction = null
var canDash = true
var dashing = false

func process(character: PlayerCharacter, delta):
	if canDash == true and character.availableDashes > 0:
		mouse_position = character.get_global_mouse_position()
		var direction = (mouse_position - character.position).normalized()
		character.position += direction * dashSpeed * delta
		canDash = false
		dashing = true
		character.dashTimer.start()
		await character.dashTimer.timeout
		canDash = true
		dashing = false
		character.availableDashes = character.availableDashes - 1
	character.change_state(character.state_moving)
