extends Node

var current_scene: Node = null

func _ready():
	current_scene = get_tree().current_scene

func change_scene(new_scene_path: String):
	if current_scene:
		current_scene.queue_free()  # Free the current scene to avoid memory leaks
	
	var new_scene = load(new_scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene
 
#Restart current scene
func restart_scene():
	if current_scene:
		var current_scene_path = current_scene.filename
		change_scene(current_scene_path)
