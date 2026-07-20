class_name MinoFollow extends State

@export var SearchState: State
@export var PursueState: State
@export var IdleState: State

@onready var pursueTimer: Timer = $"../PursueTimer"
var run_speed: int = 1200

# this is just a slightly different pursue that only updates when the player is running

func enter():
	pursueTimer.start()

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	if !parent.nav_agent.is_target_reached():
		var nav_point_direction = parent.to_local(parent.nav_agent.get_next_path_position()).normalized()
		parent.velocity = nav_point_direction * run_speed * delta
	
	if parent.nav_agent.is_navigation_finished():
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
