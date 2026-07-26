class_name PlayerRun3D extends State

@export var WalkState: State
@export var IdleState: State

func enter():
	SignalBus.emit_signal("player_running_3D", parent.position)
	Flags.player_run_state = true

func exit():
	Flags.player_run_state = false

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	# this sucks but it's also due in like 10 hrs so idc anymore
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	if input_dir:
		if Input.is_action_just_released("run"):
			return WalkState
		parent.velocity.x = input_dir.x * 150 * delta
		parent.velocity.z = input_dir.y * 150 * delta
		parent.rotation.y = rotate_toward(parent.rotation.y, Vector2(-input_dir.y, -input_dir.x).angle(), 5 * delta)
	else:
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
