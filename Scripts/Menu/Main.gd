extends Control

onready var title = $CenterContainer/VBoxContainer/CenterContainer/Title
onready var prompt = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer/Prompt
var current = false setget set_current
var time = 0

func set_current(isCurrent):
	current = isCurrent
	if isCurrent:
		MainMenu.music.get_node("Main1").play()
		$CenterContainer/VBoxContainer/CenterContainer3/HBoxContainer/Score.text = "HIGH SCORE: "+str(Globals.high_score)
	else:
		MainMenu.music.get_node("Main1").stop()
		

func _process(delta):
	if current:
		time = fmod(time + delta, PI/2)
		prompt.modulate.a = abs(sin(time * 2))
		if Input.is_action_just_pressed("ui_accept"):
			current = false
			Loader.current_scene.running = true
