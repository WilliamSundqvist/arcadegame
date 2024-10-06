extends State

func process(character: PlayerCharacter, delta: float) -> void:
	if Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("forward") || Input.is_action_pressed("backwards"):
		character.change_state(character.state_moving)
