extends StaticBody2D

onready var launch_point = $LaunchPoint
onready var cycle = $Cycle
onready var wait = $Wait
onready var tween = $Tween
onready var bullet = preload("res://Objects/Bullets/EBullet.tscn")

export(int) var hit_points = 1 setget set_health
export(int) var attack_type = 1
export(float) var speed = 100
export(Array, Dictionary) var enter_path = [{pos = Vector2.ZERO, firing = false, wait = 0}]
export(Array, Dictionary) var attack_path = [{}]
export var attacker = false
export var enter_time = 0
var velocity = Vector2.ZERO
var active = false
var firing = false
export var slices = 8
export var attack_speed = 1
var color = 0
	
func set_health(health):
	if hit_points > health:
		color = 1
	hit_points = health if (active and hit_points > health) or hit_points < health else hit_points
	if hit_points <= 0:
		queue_free()

func _ready():
	global_position = enter_path[0].pos
	yield(run_path(enter_path), "completed")
	if attacker:
		while hit_points > 0:
			yield(run_path(attack_path, true), "completed")		
	
func spawn_bullet(speed = 25):
	BulletHandler.new_bullet(launch_point.global_position, launch_point.rotation, speed, "enemy")
	if true:
		return
	var instanced_bullet = bullet.instance()
	instanced_bullet.shooter_group = "enemy"
	instanced_bullet.bullet_speed = clamp(speed+1, 4, 25)
	instanced_bullet.rotation = launch_point.rotation
	instanced_bullet.global_position = launch_point.global_position
	Loader.current_scene.add_child(instanced_bullet)	
	
func attack(speerd = 5):
	if attack_type == 0:
		launch_point.rotation = deg2rad(90)
		spawn_bullet(speerd)
	elif attack_type == 1:
		var step = (2 * PI)/slices
		launch_point.rotation += step
		spawn_bullet(speerd)
	elif attack_type == 2:
		var step = (2 * PI)/slices
		for i in range(slices):
			launch_point.rotation = step*i
			spawn_bullet(speerd)
	
func run_path(path, random = false):
	if random:
		randomize()
		path.shuffle()
	for i in path:
		if i.has("pos"):
			var distance = global_position.distance_to(i.pos)
			tween.interpolate_property(self, "global_position", global_position, i.pos, distance/speed, Tween.TRANS_LINEAR)
			tween.start()
			yield(tween, "tween_completed")
		firing = i.firing if i.has("firing") else firing
		active = i.active if i.has("active") else active
		attack_type = i.attack_type if i.has("attack_type") else attack_type
		speed = i.speed if i.has("speed") else speed
		slices = i.slices if i.has("slices") else slices
		attack_speed = i.attack_speed if i.has("attack_speed") else attack_speed
		if i.has("wait") and i.wait > 0:
			wait.wait_time = i.wait
			wait.start()
			yield(wait, "timeout")
			# yield(get_tree().create_timer(i.wait), "timeout")	
		if i.has("exit"):
			set_health(0)
	
func _physics_process(delta):
	if not active:
		return
	modulate.g = 1-color
	modulate.b = 1-color
	color = lerp(color, 0, 0.2)
	if firing and cycle.is_stopped():
		cycle.start()
		attack(attack_speed)
		
