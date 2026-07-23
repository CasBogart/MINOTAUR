class_name MinoFollow extends State

@export var SearchState: State
@export var PursueState: State
@export var IdleState: State

@onready var followTimer: Timer = $"../FollowTimer"
var run_speed: int = 1250

# this is just a slightly different pursue

func enter():
	followTimer.start()

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	if parent.lantern_following:
		if followTimer.timeout and (parent.current_lantern_raycast_collider is Lantern or parent.lantern_raycast.get_target_position().length() < 150):
			parent.nav_agent.target_position = parent.get_global_mouse_position()
	
	if not parent.nav_agent.is_navigation_finished():
		var nav_point_direction = parent.to_local(parent.nav_agent.get_next_path_position()).normalized()
		parent.velocity = nav_point_direction * run_speed * delta
	elif parent.nav_agent.is_navigation_finished():
		parent.lantern_following = false
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
