extends Area2D

onready var coin = preload("res://Objects/Coin.tscn")
onready var explosion = preload("res://Objects/Explosion.tscn")
onready var despawn = $Despawn
onready var notifier = $VisibilityNotifier2D

export(float) var bullet_speed = 25
export(String) var shooter_group = "player"

export var length = 15
var point = Vector2()
var velocity = Vector2()

func _ready():
	velocity = Vector2(bullet_speed, 0).rotated(rotation)

func _physics_process(delta):
	global_position += velocity
	if not notifier.is_on_screen():
		_on_Bullet_body_entered(null)
	
func _on_Bullet_body_entered(body):
	if body != null and not body.is_in_group(shooter_group):
		var isPlayer = body == Globals.player
		var despawning = Globals.player.get_node("Timers").get_node("Damage").is_stopped() if isPlayer and Globals.player.active else false
		if body.hit_points > 0:
			body.hit_points -= 1
		if body.active and body.hit_points <= 0:
			body.active = false
			var instanced_explosion = explosion.instance()
			instanced_explosion.global_position = global_position
			get_parent().call_deferred("add_child", instanced_explosion)
			if shooter_group == "player":
				for i in range(7):
					var instanced_coin = coin.instance()
					instanced_coin.global_position = global_position + Vector2(rand_range(-50, 50), rand_range(-25, 25))
					get_parent().call_deferred("add_child", instanced_coin)
		if despawning or body.is_in_group("enemy"):
			queue_free()
	elif body == null:
		queue_free()
