class_name PlayerWalk3D extends State

@export var RunState: State
@export var IdleState: State

func enter():
	pass

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	# this sucks but it's also due in like 10 hrs so idc anymore
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	if input_dir:
		if Input.is_action_pressed("run"):
			return RunState
		parent.velocity.x = input_dir.x * 100 * delta
		parent.velocity.z = input_dir.y * 100 * delta
		parent.rotation.y = rotate_toward(parent.rotation.y, Vector2(-input_dir.y, -input_dir.x).angle(), 10 * delta)
	else:
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
