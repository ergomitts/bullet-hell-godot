extends Control

onready var scores = $CenterContainer/VBoxContainer/CenterContainer/Score
onready var prompt = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer/Prompt
var current = false setget set_current
var time = 0

func set_current(isCurrent):
	current = isCurrent
	if isCurrent:
		MainMenu.music.get_node("Main1").play()
		scores.text = "SCORE: " + str(Globals.player.score)
	else:
		MainMenu.music.get_node("Main1").stop()
		

func _process(delta):
	if current:
		time = fmod(time + delta, PI/2)
		prompt.modulate.a = abs(sin(time * 2))
		if Input.is_action_just_pressed("ui_accept"):
			current = false
			MainMenu.set_screen("Main")
