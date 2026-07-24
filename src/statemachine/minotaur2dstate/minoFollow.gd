class_name MinoFollow extends State

@export var SearchState: State
@export var PursueState: State
@export var IdleState: State

@onready var followTimer: Timer = $"../FollowTimer"
var run_speed: int = 1250
var max_distance: int

# this is just a slightly different pursue

func enter():
	max_distance = 1000
	followTimer.start()

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	if not parent.nav_agent.is_navigation_finished():
		var nav_point_direction = parent.to_local(parent.nav_agent.get_next_path_position()).normalized()
		parent.velocity = nav_point_direction * run_speed * delta
	elif parent.nav_agent.is_navigation_finished():
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
