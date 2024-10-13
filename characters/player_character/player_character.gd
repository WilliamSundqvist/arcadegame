extends CharacterBody2D
class_name PlayerCharacter
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var dashTimer: Timer = $dashTimer
@onready var fireTimer = $fireTimer
@onready var q_timer: Timer = $QTimer
@onready var e_timer: Timer = $ETimer

@onready var projectile = load("res://spells/basic_projectile/basicProjectile.tscn")
@onready var brand_w = load("res://spells/brand_w/BrandW.tscn")
@onready var lux_r = load("res://spells/lux_r/lux_r.tscn")
@onready var blastEffect = load("res://effects/blastEffect.tscn")

var current_state: State = null
var state_moving = preload("res://characters/player_character/states/moving.gd").new()
var state_idle = preload("res://characters/player_character/states/idle.gd").new()
var state_dash = preload("res://characters/player_character/states/dash.gd").new()

var availableDashes = 3
var fireRate = 0.1
var q_fire_rate = 2
var e_fire_rate = 4
var current_velocity = 0

var is_casting_spell = false

func _ready():
	change_state(state_moving)

func _physics_process(delta):
	if current_state:
		current_state.process(self, delta) #All logic is processed in ./states/ idle&moving&casting&taking_damage&etc
	
	if Input.is_action_pressed("shoot") and fireTimer.is_stopped():
		shoot()
		fireTimer.start(fireRate)
	
	if Input.is_action_pressed("Q") and q_timer.is_stopped():
		cast_q_spell()
		q_timer.start(q_fire_rate)
	
	if Input.is_action_pressed("E") and e_timer.is_stopped():
		cast_e_spell()
		e_timer.start(e_fire_rate)
		
		
func change_state(new_state: State):
	if current_state:
		current_state.exit(self)
	current_state = new_state
	if current_state:
		current_state.enter(self)
		
func shoot():
	var level_root = get_parent().get_parent()
	var effect = blastEffect.instantiate()
	
	#Add the current velocity so the blast effect spawns a little infront of the character
	effect.markerPosition = $Sprite/Marker2D.global_position + current_velocity/3.0 
	level_root.add_child(effect)
	
	var instance = projectile.instantiate()
	instance.targetPosition = get_global_mouse_position()
	instance.markerPosition = $Sprite/Marker2D.global_position
	level_root.add_child(instance)
	
func cast_q_spell():
	var level_root = get_parent().get_parent()
	var brand_w_instance = brand_w.instantiate()
	brand_w_instance.global_position = get_global_mouse_position()
	level_root.add_child(brand_w_instance)

func cast_e_spell():
	is_casting_spell = true
	
	var mouse_position = get_global_mouse_position()
	
	var level_root = get_parent().get_parent()
	
	var lux_r_instance = lux_r.instantiate()
	
	lux_r_instance.player = self
	
	lux_r_instance.global_position = global_position
	
	# Calculate the direction from the spell to the mouse position
	var direction_to_mouse = mouse_position - global_position

	# Get the angle to rotate the spell towards the mouse
	var angle_to_mouse = direction_to_mouse.angle()

	# Apply the rotation to the spell instance
	lux_r_instance.rotation = angle_to_mouse
	
	level_root.add_child(lux_r_instance)
	
	
