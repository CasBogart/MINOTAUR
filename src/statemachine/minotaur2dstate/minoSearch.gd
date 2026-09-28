class_name MinoSearch extends State

# other states from here
@export var IdleState: State
@export var PursueState: State
@export var FollowState: State

var search_speed: int = 750

func enter():
	# find player position
	parent.nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").position
	# modify position by small x and y values for offset, appears like wandering in general area
	parent.nav_agent.target_position.x += randi_range(-20, 20)
	parent.nav_agent.target_position.y += randi_range(-20, 20)

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	# if navigation to target position isn't finished
	if not parent.nav_agent.is_navigation_finished():
		# move to next point on nav path
		var nav_point_direction = parent.to_local(parent.nav_agent.get_next_path_position()).normalized()
		parent.velocity = nav_point_direction * search_speed * delta
	# if it is finished
	elif parent.nav_agent.is_navigation_finished():
		# idle state
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
