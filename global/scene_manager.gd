extends Node

var current_scene: Node = null
var current_path: String

func _ready():
	current_scene = get_tree().current_scene

func change_scene(new_scene_path: String):
	if current_scene:
		current_scene.queue_free()  # Free the current scene to avoid memory leaks
	current_path = new_scene_path
	
	var new_scene = load(new_scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene
 
#Restart current scene
func restart_scene():
	if current_scene:
		change_scene(current_path)
