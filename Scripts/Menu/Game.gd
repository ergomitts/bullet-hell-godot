extends Control

onready var nuke = $Nuke
var current = false setget set_current
var nuke_time = 0

func set_current(isCurrent):
	current = isCurrent
	if isCurrent:
		update_hud()
		MainMenu.music.get_node("Main"+ str(randi()%MainMenu.music.get_child_count()+1)).play()

func update_hud():
	if Globals.player:
		for i in range(1, 4):
			$Bombs.get_node(str(i)).visible = true if i <= Globals.player.bombs else false
		for i in range(1, 6):
			$Health.get_node(str(i)).visible = true if i <= Globals.player.hit_points else false
		$SCORE.text = "SCORE: " + str(Globals.player.score)

func _process(delta):
	nuke_time = lerp(nuke_time, 0, 1.7 * delta)
	nuke.modulate.a = nuke_time
