extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var charge_player: AudioStreamPlayer = $ChargePlayer
@onready var blast_player: AudioStreamPlayer = $BlastPlayer

var player: PlayerCharacter
var damage = 50
var damage_interval = 0.3

func _ready():
	animated_sprite_2d.play("aim")
	charge_player.play()
	get_tree().create_timer(0.5).timeout.connect(aim_finished)

func aim_finished():
	blast_player.play()
	animated_sprite_2d.play("charge")
	get_tree().create_timer(0.5).timeout.connect(charge_finished)

	
func charge_finished():
	animated_sprite_2d.play("blast")
	get_tree().create_timer(0.3).timeout.connect(blast_finished)
	
	damage_enemies()
	
	var damage_over_time_timer = Timer.new()
	add_child(damage_over_time_timer)
	damage_over_time_timer.wait_time = damage_interval
	damage_over_time_timer.timeout.connect(damage_enemies)
	damage_over_time_timer.autostart = true
	damage_over_time_timer.start()

func blast_finished():
	player.is_casting_spell = false
	queue_free()

func damage_enemies():
	# Get all overlapping bodies or areas inside the Area2D
	for area in get_overlapping_areas():
		# Check if the object has a 'damage' method, then apply damage
		if area.has_method("damage"):
			area.damage(damage)  # Call the damage method on the object
