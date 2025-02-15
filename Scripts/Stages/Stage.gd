extends Node

signal finished 

func _physics_process(delta):
	if get_child_count() == 0 or (not Globals.player or not Globals.player.active):
		emit_signal("finished")
