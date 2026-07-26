class_name MinoFollow3D extends State

@export var SearchState: State
@export var PursueState: State
@export var IdleState: State

@onready var follow_timer: Timer = $"../FollowTimer"
var run_speed: int = 1300

func enter():
	parent.anim_player.play("follow")

func exit():
	follow_timer.stop()

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	if not parent.nav_agent.is_navigation_finished():
		var nav_point_direction = parent.to_local(parent.nav_agent.get_next_path_position()).normalized()
		parent.velocity.x = nav_point_direction.x * run_speed * delta
		parent.velocity.z = nav_point_direction.y * run_speed * delta
	elif parent.nav_agent.is_navigation_finished():
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
