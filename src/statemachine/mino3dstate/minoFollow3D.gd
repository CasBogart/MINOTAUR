class_name MinoFollow3D extends State

func enter():
	parent.anim_player.play("follow")

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta) -> State:
	return null

func process(_delta) -> State:
	return null
