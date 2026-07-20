class_name MinoPursue extends State

@export var SearchState: State

@onready var pursueTimer: Timer = $"../PursueTimer"
var run_speed: int = 1350

func enter():
	parent.nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").position
	pursueTimer.start()

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	if !parent.nav_agent.is_target_reached():
		var nav_point_direction = parent.to_local(parent.nav_agent.get_next_path_position()).normalized()
		parent.velocity = nav_point_direction * run_speed * delta
	
	if parent.nav_agent.path_return_max_radius < parent.to_local(parent.nav_agent.get_path_length()).normalized():
		return SearchState
	
	if pursueTimer.timeout:
		parent.nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").position
	
	return null

func process(_delta) -> State:
	return null
