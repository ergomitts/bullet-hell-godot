extends MeshInstance2D

var group = null
var velocity = Vector2(0, 0)
var active = false
var speed = 1

const SHAPE = preload("res://Objects/Bullets/BulletShape.tres")

var query = Physics2DShapeQueryParameters.new()
onready var direct_space_state = get_world_2d().direct_space_state

var travelled_distance = 0

signal hit

func _init():
	query.set_shape(SHAPE)
	query.collide_with_bodies = true
	query.collision_layer = 2
	set_as_toplevel(true)
	
func _physics_process(delta):
	query.transform = global_transform
	travelled_distance += speed * delta
	var result = direct_space_state.intersect_shape(query, 1)
	if result:
		emit_signal("hit", self, result[0].collider)
	elif travelled_distance > 900:
		emit_signal("hit", self, null)

func _on_Bullet_body_entered(body):
	if true:
		return
	if active:
		emit_signal("hit", self, body)
