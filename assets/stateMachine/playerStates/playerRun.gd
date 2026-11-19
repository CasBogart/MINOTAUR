class_name PlayerRun extends State

@export var IdleState : State # able to transition to idle
@export var WalkState : State # able to transition to walk

@export var run_speed : float # run speed

func enter():
	pass

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	# is there an input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	# if there is
	if input_dir:
		# but you're not running
		if Input.is_action_just_released("run"):
			# return walkstate
			return WalkState
		# move at new fun runspeed
		parent.velocity = input_dir * run_speed * delta
	# otherwise there's no input so you're idling
	else:
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
