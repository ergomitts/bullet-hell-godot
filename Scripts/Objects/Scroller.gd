extends ParallaxBackground

export(float) var scroll_speed = 100

func _ready():
	pass
	
func _process(delta):
	scroll_offset.y = fmod(scroll_offset.y + scroll_speed * delta, 1024)
