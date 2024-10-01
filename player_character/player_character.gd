extends CharacterBody2D
class_name PlayerCharacter
@onready var sprite: Sprite2D = $Sprite

@export var camera: Camera2D

var current_state: State = null
var state_moving = preload("res://player_character/states/moving.gd").new()
var state_idle = preload("res://player_character/states/idle.gd").new()

func _ready():
	change_state(state_moving)

func _physics_process(delta):
	if current_state:
		current_state.process(self, delta) #All logic is processed in ./states/ idle&moving&casting&taking_damage&etc

func change_state(new_state: State):
	if current_state:
		current_state.exit(self)
	current_state = new_state
	if current_state:
		current_state.enter(self)
