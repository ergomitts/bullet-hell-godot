extends Sprite

func _ready():
	$AnimationPlayer.play("Explosion", -1, 1)
	$Boom.play()
	yield($AnimationPlayer, "animation_finished")
	queue_free()
