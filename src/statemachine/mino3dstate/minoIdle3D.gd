class_name MinoIdle3D extends State

@export var SearchState: State
@export var PursueState: State
@export var FollowState: State

@onready var idle_timer: Timer = $"../IdleTimer"

func enter():
	parent.velocity = Vector3(0, 0, 0)
	parent.anim_player.play("idle")
	idle_timer.start(3.5)

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta) -> State:
	if idle_timer.is_stopped() and not Flags.input_paused:
		return SearchState
	
	return null

func process(_delta) -> State:
	return null
