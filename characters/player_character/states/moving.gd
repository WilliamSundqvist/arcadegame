extends State

@export var acceleration: float = 1000.0   # How fast the character accelerates
@export var deceleration: float = 500.0    # How fast the character decelerates
@export var max_speed: float = 200.0       # Maximum speed when running
@export var walk_speed: float = 100.0      # Speed when walking
@export var run_speed: float = 200.0       # Speed when sprinting

var velocity = Vector2.ZERO

func process(character: PlayerCharacter, delta):
	var input_vector = Vector2.ZERO
	var move_speed = walk_speed  # Default to walking speed

	# Handle sprinting (running)
	if Input.is_action_pressed("sprint"):
		move_speed = run_speed
	if Input.is_action_just_pressed("dash"):
		character.change_state(character.state_dash)
	# Collect input for WASD movement
	if Input.is_action_pressed("left"):
		input_vector.x -= 1  # Move left
		character.sprite.flip_h = true  # Flip the sprite horizontally when moving left
	elif Input.is_action_pressed("right"):
		input_vector.x += 1  # Move right
		character.sprite.flip_h = false  # Ensure sprite is not flipped when moving right

	if Input.is_action_pressed("up"):
		input_vector.y -= 1  # Move up
	elif Input.is_action_pressed("down"):
		input_vector.y += 1  # Move down

	# Normalize the vector for consistent diagonal movement speed
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	# Accelerate towards input direction
	velocity = velocity.move_toward(input_vector * move_speed, acceleration * delta)

	# Decelerate when no input is provided
	if input_vector == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

	# Move the character based on the calculated velocity
	character.current_velocity = velocity
	character.position += velocity * delta

	# Animation handling
	#if input_vector != Vector2.ZERO:
		#character.play_animation("walk")  # Play walk animation if moving
	#else:
		#character.play_animation("idle")  # Play idle animation if not moving
