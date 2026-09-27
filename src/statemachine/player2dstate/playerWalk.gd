class_name PlayerWalk extends State

# export other states
@export var IdleState: State
@export var RunState: State

func enter():
	pass

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	# find normalized input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	# if there is one
	if input_dir:
		# and player is running
		if Input.is_action_pressed("run"):
			# start running
			return RunState
		# otherwise, set velocity
		parent.velocity = input_dir * 750 * delta
	# if there's no input direction
	else:
		# enter idle
		return IdleState
	
	return null

func process(_delta) -> State:
	# probably a better way to do this but idc
	parent.animated_sprite.set_speed_scale(1)
	
	# this is all for changing the sprite around to face the correct direction and play the correct animation
	if Input.is_action_pressed("move_right"):
		parent.animated_sprite.flip_h = false
		parent.animated_sprite.play("walkside")
	elif Input.is_action_pressed("move_left"):
		parent.animated_sprite.flip_h = true
		parent.animated_sprite.play("walkside")
	elif Input.is_action_pressed("move_up"):
		parent.animated_sprite.flip_h = false
		parent.animated_sprite.play("walkbackwards")
	elif Input.is_action_pressed("move_down"):
		parent.animated_sprite.flip_h = false
		parent.animated_sprite.play("walkforward")
	
	return null
