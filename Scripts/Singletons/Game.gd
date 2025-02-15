extends Node2D

const SAVE_DIR = "./"

onready var player_scene = preload("res://Objects/Player.tscn")
var running = false setget run_game
var stage_index = 0
var current_stage = null
var stages = []

func _ready():
	var path = "res://Scenes/Stages/"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif !file_name.begins_with("."):
			stages.append(load(path + file_name))
	dir.list_dir_end()
	var file = File.new()
	if file.file_exists(SAVE_DIR + "save.dat"):
		var error = file.open_encrypted_with_pass(SAVE_DIR + "save.dat", File.READ, "AMONGUS")
		if error == OK:
			var player_data = file.get_var()
			file.close()
			Globals.high_score = player_data.high_score
			MainMenu.screens.Main.get_node("CenterContainer").get_node("VBoxContainer").get_node("CenterContainer3").get_node("HBoxContainer").get_node("Score").text = "HIGH SCORE: "+str(Globals.high_score)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		var dir = Directory.new()
		if !dir.dir_exists(SAVE_DIR):
			dir.make_dir_recursive(SAVE_DIR)
			
		var file = File.new()
		var error = file.open_encrypted_with_pass(SAVE_DIR + "save.dat", File.WRITE, "AMONGUS")
		if error == OK:
			file.store_var({"high_score": Globals.high_score})
			file.close()
			
		get_tree().quit()

func nuke():
	for i in BulletHandler.bullets:
		BulletHandler.destroy_bullet(i, null)

func run_stage(stage):
	if stages[stage] and current_stage == null:
		var instanced_stage = stages[stage].instance()
		add_child(instanced_stage)
		current_stage = instanced_stage

func run_game(isRunning):
	running = isRunning
	if running:
		stage_index = 0
		current_stage = null
		var instanced_player = player_scene.instance()
		instanced_player.global_position = get_viewport_rect().size/2
		add_child(instanced_player)
		Globals.player = instanced_player
		MainMenu.set_screen("Game")
		while Globals.player and Globals.player.hit_points > 0:
			if stage_index < stages.size():
				run_stage(stage_index)
				yield(current_stage, "finished")
				current_stage.queue_free()
				current_stage = null
				stage_index += 1
				if Globals.player.hit_points > 0:
					Globals.player.hit_points = 5
					Globals.player.bombs = 3
			else:
				break
		yield(get_tree().create_timer(3), "timeout")
		for i in MainMenu.music.get_children():
			i.stop()
		MainMenu.set_screen("Scores")
		if Globals.player:
			Globals.high_score = Globals.player.score if Globals.player and Globals.player.score > Globals.high_score else Globals.high_score
			Globals.player.queue_free()
		for i in BulletHandler.bullets:
			BulletHandler.destroy_bullet(i, null)
		for i in get_tree().get_nodes_in_group("coin"):
			i.queue_free()
	else:
		MainMenu.set_screen("Death")
		
