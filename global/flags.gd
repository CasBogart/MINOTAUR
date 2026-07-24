extends Node

# 0 is tutorial, 1 minotaur, 2 dark, 3 mino faster, 4 funny
var level: int = 1

var here_before: bool = false
var input_paused: bool = false
var exit_coords: Vector2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
