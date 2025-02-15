extends CanvasLayer

onready var rect = $ColorRect
onready var music = $Music
var screens = {}
var current_screen = null

func _ready():
	for i in $Screens.get_children():
		screens[i.name] = i 
	set_screen("Main")
	
func set_screen(screen):
	screen = screens[screen] if screens.has(screen) else null
	if screen != current_screen:
		current_screen = screen
		for i in $Screens.get_children():
			i.visible = true if i == current_screen else false
			i.current = i == current_screen
