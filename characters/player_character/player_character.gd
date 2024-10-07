extends CharacterBody2D
class_name PlayerCharacter
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var dashTimer: Timer = $dashTimer
@onready var fireTimer = $fireTimer
@onready var q_timer: Timer = $QTimer
@onready var projectile = load("res://spells/basic_projectile/basicProjectile.tscn")
@onready var brand_w = load("res://spells/brand_w/BrandW.tscn")
@export var camera: Camera2D
@onready var blastEffect = load("res://effects/blastEffect.tscn")
var current_state: State = null
var state_moving = preload("res://characters/player_character/states/moving.gd").new()
var state_idle = preload("res://characters/player_character/states/idle.gd").new()
var state_dash = preload("res://characters/player_character/states/dash.gd").new()

var availableDashes = 3
var fireRate = 0.1
var q_fire_rate = 2
var current_velocity = 0

func _ready():
	change_state(state_moving)

func _physics_process(delta):
	if current_state:
		current_state.process(self, delta) #All logic is processed in ./states/ idle&moving&casting&taking_damage&etc
	
	if Input.is_action_pressed("shoot") and fireTimer.is_stopped():
		shoot()
		fireTimer.start(fireRate)
	
	if Input.is_action_pressed("Q") and q_timer.is_stopped():
		cast_spell()
		q_timer.start(q_fire_rate)
		
		
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
	
func cast_spell():
	var level_root = get_parent().get_parent()
	var brand_w_instance = brand_w.instantiate()
	brand_w_instance.global_position = get_global_mouse_position()
	level_root.add_child(brand_w_instance)

	
	
