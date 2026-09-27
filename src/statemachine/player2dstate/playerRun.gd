class_name PlayerRun extends State

# onready the timer to calculate last known position
@onready var run_timer: Timer = $"../RunTimer"

# export other states
@export var IdleState: State
@export var WalkState: State

func enter():
	# emit signal for running with last discovered position
	SignalBus.emit_signal("player_running", parent.position)
	# start timer to recalculate last discovered position
	run_timer.start()
	# set global flag
	Flags.player_run_state = true

func exit():
	# set global flag
	Flags.player_run_state = false
	# stop the timer so that we're not still calculating location 
	run_timer.stop()

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	# find normalized input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	# if there is one
	if input_dir:
		# but not trying to run
		if Input.is_action_just_released("run"):
			# enter walk state
			return WalkState
		# otherwise, move at this velocity
		parent.velocity = input_dir * 1000 * delta
	# if there's no input at all
	else:
		# idle
		return IdleState
	
	return null

func process(_delta) -> State:
	# again, just for direction and animation, but faster this time
	parent.animated_sprite.set_speed_scale(1.75)
	
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
	
	# if the run timer has run out
	if run_timer.timeout:
		# update last known position
		SignalBus.emit_signal("player_running", parent.position)
		# restart the timer
		run_timer.start()
	
	return null
