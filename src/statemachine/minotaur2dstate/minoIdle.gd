class_name MinoIdle extends State

@export var SearchState: State
@export var PursueState: State
@export var FollowState: State

@onready var idle_timer: Timer = $"../IdleTimer"

func enter():
	parent.velocity = Vector2(0, 0)
	idle_timer.start(0.5)

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta) -> State:
	if idle_timer.is_stopped():
		return SearchState
	
	return null

func process(_delta) -> State:
	return null
