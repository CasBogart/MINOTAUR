class_name MinoPursue3D extends State

func enter():
	parent.anim_player.play("pursue")

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta) -> State:
	return null

func process(_delta) -> State:
	return null
