class_name PlayerIdle3D extends State

@export var WalkState: State
@export var RunState: State

func enter():
	parent.velocity = Vector3(0, 0, 0)

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	if Input.get_vector("move_left", "move_right", "move_up", "move_down") and not Input.is_action_pressed("run"):
		return WalkState
	elif Input.get_vector("move_left", "move_right", "move_up", "move_down") and Input.is_action_pressed("run"):
		return RunState
	return null

func process_physics(_delta) -> State:
	return null

func process(_delta) -> State:
	return null
