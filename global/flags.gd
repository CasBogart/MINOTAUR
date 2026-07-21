extends Node

# 0 is tutorial, 1 minotaur, 2 dark, 3 no icon, 4 no map, 5 funny
var level: int = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
