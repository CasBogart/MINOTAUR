class_name PlayerRun extends State

@export var IdleState: State
@export var WalkState: State

func enter():
	pass

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	if input_dir:
		if Input.is_action_just_released("run"):
			return WalkState
		parent.velocity = input_dir * 1750 * delta
	else:
		return IdleState
	
	return null

func process(_delta) -> State:
		# probably a better way to do this but idc
	parent.animated_sprite.set_speed_scale(1.25)
	
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
