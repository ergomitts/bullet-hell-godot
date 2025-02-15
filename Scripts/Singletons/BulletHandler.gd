extends Node

const MAX_BULLETS = 10001

onready var bullet = preload("res://Objects/Bullets/EBullet2.tscn")
onready var coin = preload("res://Objects/Coin.tscn")
onready var explosion = preload("res://Objects/Explosion.tscn")

var bullets = []
var index = 0

func new_bullet(position, rotation, speed, group):
#	print(bullets.size())
	if bullets.size() < MAX_BULLETS:
		var instanced_bullet = bullet.instance()
		instanced_bullet.global_position = position
		instanced_bullet.rotation = rotation
		instanced_bullet.velocity = Vector2(speed, 0).rotated(rotation)
		instanced_bullet.group = group
		instanced_bullet.speed = speed
		add_child(instanced_bullet)
		bullets.append(instanced_bullet)
		instanced_bullet.active = true
		instanced_bullet.connect("hit", self, "destroy_bullet") 
	else:
		bullets[index].global_position = position
		bullets[index].rotation = rotation
		bullets[index].velocity = Vector2(speed, 0).rotated(rotation)
		bullets[index].group = group
		bullets[index].show()
		bullets[index].active = true
		index = fmod(index + 1, MAX_BULLETS)

func destroy_bullet(bull, body):
	if body != null and not body.is_in_group(bull.group):
		var isPlayer = body == Globals.player
		var despawning = Globals.player.get_node("Timers").get_node("Damage").is_stopped() if isPlayer and Globals.player.active else false
		if body.hit_points > 0:
			body.hit_points -= 1
		if body.active and body.hit_points <= 0:
			body.active = false
			var instanced_explosion = explosion.instance()
			instanced_explosion.global_position = bull.global_position
			get_parent().call_deferred("add_child", instanced_explosion)
			if bull.group == "player":
				for i in range(7):
					var instanced_coin = coin.instance()
					instanced_coin.global_position = bull.global_position + Vector2(rand_range(-50, 50), rand_range(-25, 25))
					get_parent().call_deferred("add_child", instanced_coin)
		if despawning or body.is_in_group("enemy"):
			bull.global_position = Vector2.ZERO
			bull.active = false
			bull.hide()
	elif body == null:
		bull.global_position = Vector2.ZERO
		bull.active = false
		bull.hide()

func _physics_process(delta):
	for i in bullets:
		if i.active:
			i.global_position += i.velocity
			if not i.get_node("VisibilityNotifier2D").is_on_screen():
				destroy_bullet(i, null)
			
		
