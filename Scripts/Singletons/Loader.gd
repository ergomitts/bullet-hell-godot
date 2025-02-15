extends Node

export(bool) var DEBUGGING = false
export(String) var SCENES_PATH = "res://Scenes/"
onready var main_scene = get_tree().get_current_scene()
onready var current_scene = null

func _ready():
	load_scene("Game")
	
func load_scene(scene):
	call_deferred("_deferred_load_scene", scene)
	
func _deferred_load_scene(scene):
	get_tree().paused = true
	if current_scene:
		current_scene.queue_free()
	var loaded_scene = load(SCENES_PATH + scene + ".tscn")
	if !loaded_scene:
		assert(loaded_scene != null, "Loaded scene is null. Make sure to remember that %s and .tscn are not needed for the path arguements." % SCENES_PATH)
		return
	var instanced_scene = loaded_scene.instance()
	main_scene.call_deferred("add_child", instanced_scene)
	current_scene = instanced_scene
	get_tree().paused = false
