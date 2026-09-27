class_name PlayerIdle extends State

# export other states
@export var WalkState: State
@export var RunState: State

func enter():
	# set velocity to 0
	parent.velocity = Vector2(0, 0)

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta) -> State:
	# if there's input and no attempt to run
	if Input.get_vector("move_left", "move_right", "move_up", "move_down") and not Input.is_action_pressed("run"):
		# walk state
		return WalkState
	# if there is input and an attempt to run
	elif Input.get_vector("move_left", "move_right", "move_up", "move_down") and Input.is_action_pressed("run"):
		# run state
		return RunState
	
	return null

func process(_delta) -> State:
	# reset speed to normal if coming out of running
	parent.animated_sprite.set_speed_scale(1)
	# set to first frame of animation
	parent.animated_sprite.set_frame(1)
	
	return null
