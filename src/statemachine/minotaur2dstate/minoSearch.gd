class_name MinoSearch extends State

@export var IdleState: State
@export var PursueState: State

var search_speed: int = 600

func enter():
	parent.nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").position
	parent.nav_agent.target_position.x += randi_range(-20, 20)
	parent.nav_agent.target_position.y += randi_range(-20, 20)

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	if not parent.nav_agent.is_navigation_finished():
		var nav_point_direction = parent.to_local(parent.nav_agent.get_next_path_position()).normalized()
		parent.velocity = nav_point_direction * search_speed * delta
	elif parent.nav_agent.is_navigation_finished():
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
