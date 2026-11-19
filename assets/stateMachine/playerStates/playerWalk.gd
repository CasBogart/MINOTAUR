class_name PlayerWalk extends State

@export var IdleState : State # able to transition to idle
@export var RunState : State # able to transition to run

@export var walk_speed : float # walk speed

func enter():
	pass

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	# normalize input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	# if there's an input direction
	if input_dir:
		# if there's input to run
		if Input.is_action_pressed("run"):
			# enter runstate
			return RunState
		# move according to walkspeed
		# "oh its good for frame rate issues" shut up i hate using delta time
		parent.velocity = input_dir * walk_speed * delta
	# if there's not an input direction return idlestate
	else:
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
