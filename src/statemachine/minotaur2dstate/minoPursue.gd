class_name MinoPursue extends State

@export var SearchState: State
@export var IdleState: State
@export var FollowState: State

@onready var pursueTimer: Timer = $"../PursueTimer"
var run_speed: int = 1500

func enter():
	parent.nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").position
	pursueTimer.start()

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	if not parent.nav_agent.is_target_reached():
		var nav_point_direction = parent.to_local(parent.nav_agent.get_next_path_position()).normalized()
		parent.velocity = nav_point_direction * run_speed * delta
	
	if pursueTimer.timeout:
		parent.nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").position

	if parent.raycast.get_target_position().length() < 250 and not parent.raycast.get_collider() is CharacterBody2D:
		# there's an issue rn where after following it just starts idling, this is mostly bc there isn't a player death implemented yet
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
