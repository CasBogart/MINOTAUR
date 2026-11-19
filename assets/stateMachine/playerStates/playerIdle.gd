class_name PlayerIdle extends State

@export var WalkState : State # able to transition to walk
@export var RunState : State # able to transition to run

func enter():
	# on entry, set velocity to zero
	parent.velocity = Vector2(0, 0)
	print("idle entered")

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta) -> State:
	# Not really a glitch, but something to note if adding sliding later:
	# when making a 180-degree turn, briefly resets to IdleState.
	# Implement delta velocity-dependent entry/exit?
	
	# if there's input to move but no input to run
	if Input.get_vector("move_left", "move_right", "move_up", "move_down") and not Input.is_action_pressed("run"):
		# move to walkstate
		return WalkState
	# otherwise if there is input to run
	elif Input.get_vector("move_left", "move_right", "move_up", "move_down") and Input.is_action_pressed("run"):
		# move to runstate
		return RunState
	
	return null

func process(_delta) -> State:
	return null
