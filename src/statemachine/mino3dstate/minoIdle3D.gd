class_name MinoIdle3D extends State

func enter():
	parent.velocity = Vector3(0, 0, 0)
	parent.anim_player.play("idle")

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta) -> State:
	return null

func process(_delta) -> State:
	return null
