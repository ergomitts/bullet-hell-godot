extends Area2D

onready var collect = $Collect
onready var despawn = $Despawn

func _physics_process(delta):
	if Globals.player and Globals.player.global_position.distance_to(global_position) < 150 and Globals.player.hit_points > 0:
		global_position.x = lerp(global_position.x, Globals.player.global_position.x, 0.2)
		global_position.y = lerp(global_position.y, Globals.player.global_position.y, 0.2)

func _on_Coin_body_entered(body):
	if body.is_in_group("player"):
		if rand_range(1, 5) < 2:
			body.score += 25
			body.timers.get_node("PowerUp").start()
		else:
			body.score += 50
		queue_free()

func _on_Despawn_timeout():
	queue_free()
