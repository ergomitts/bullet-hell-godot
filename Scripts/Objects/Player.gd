extends KinematicBody2D

onready var launch_point = $LaunchPoint
onready var animation_player = $AnimationPlayer
onready var timers = $Timers
onready var sounds = $Sounds
onready var og_scale = $Sprite.scale
onready var bullet = preload("res://Objects/Bullets/Bullet.tscn")

export(int) var hit_points = 5 setget set_health
export(int) var bombs = 3 setget set_bombs
export(int) var score = 0 setget set_score
export(int) var attack_type = 0
export(int) var slices = 3
export(float) var speed_multiplier = 1
export(float) var speed = 300
export(float) var speed_walk = 100
var velocity = Vector2.ZERO
var active = true
	
func set_health(health):
	if hit_points > health and timers.get_node("Damage").is_stopped():
		timers.get_node("Damage").start()
		hit_points -= 1
		if hit_points <= 0:
			sounds.get_node("Death").play()
			hide()
		else:
			animation_player.stop()
			animation_player.play("Damage")
			sounds.get_node("Damage").play()
	elif hit_points < health:
		hit_points = health
	MainMenu.screens.Game.update_hud()
		
func spawn_bullet(speed = 25):
	var instanced_bullet = bullet.instance()
	instanced_bullet.shooter_group = "player"
	instanced_bullet.bullet_speed = speed
	instanced_bullet.rotation = launch_point.rotation
	instanced_bullet.global_position = launch_point.global_position
	Loader.current_scene.add_child(instanced_bullet)			
		
func attack(speerd = 20):
	if attack_type == 0:
		launch_point.rotation = deg2rad(-90)
		spawn_bullet(speerd)
	elif attack_type == 1:
		var angle = -25
		var step = deg2rad(angle)/slices
		for i in range(slices):
			launch_point.rotation = deg2rad(-90 - angle/slices) + step*i
			spawn_bullet(speerd)		
		
func set_bombs(bomb):
	if bombs > bomb:
		MainMenu.screens.Game.nuke_time = 1
		MainMenu.get_node("Sounds").get_node("Nuke").play()
	bombs = bomb
	MainMenu.screens.Game.update_hud()

func set_score(nscore):
	score = nscore
	MainMenu.screens.Game.update_hud()
	
func _physics_process(delta):
	if not active:
		return
	var motion = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		motion.x -= 1
	if Input.is_action_pressed("ui_right"):
		motion.x += 1
	if Input.is_action_pressed("ui_down"):
		motion.y += 1
	if Input.is_action_pressed("ui_up"):
		motion.y -= 1
	motion = motion.normalized()
	velocity = move_and_slide(motion * (speed if !Input.is_action_pressed("walk") else speed_walk) * speed_multiplier)
	global_position = Vector2(clamp(global_position.x, 0, get_viewport_rect().size.x), clamp(global_position.y, 0, get_viewport_rect().size.y))
	$Sprite.scale.x = lerp($Sprite.scale.x, og_scale.x, 0.3)
	$Sprite.scale.y = lerp($Sprite.scale.y, og_scale.y, 0.3)
	attack_type = 1 if not timers.get_node("PowerUp").is_stopped() else 0
	if Input.is_action_pressed("ui_accept") and timers.get_node("Cycle").is_stopped():
		timers.get_node("Cycle").start()
		sounds.get_node("Fire").play()
		sounds.get_node("Fire").pitch_scale = rand_range(0.7, 1.6)
		$Sprite.scale = og_scale * 1.25
		attack()
	if Input.is_action_just_pressed("nuke") and timers.get_node("Bomb").is_stopped() and bombs > 0:
		timers.get_node("Bomb").start()
		set_bombs(bombs - 1)
		Loader.current_scene.nuke()
		
