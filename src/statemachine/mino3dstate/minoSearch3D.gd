class_name MinoSearch3D extends State

@export var IdleState: State
@export var PursueState: State
@export var FollowState: State

var search_speed: int = 120

func enter():
	parent.anim_player.play("search")
	parent.nav_agent.target_position = Vector3(get_tree().get_first_node_in_group("minotarget").position.x, 0, get_tree().get_first_node_in_group("minotarget").position.z)
	print(parent.nav_agent.target_position)
	parent.nav_agent.target_position.x += randi_range(-2, 2)
	parent.nav_agent.target_position.z += randi_range(-2, 2)
	print(parent.nav_agent.target_position)

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta) -> State:
	if not parent.nav_agent.is_navigation_finished():
		var nav_point_direction = parent.nav_agent.get_next_path_position().normalized()
		parent.velocity.x = nav_point_direction.x * search_speed * delta
		parent.velocity.z = nav_point_direction.y * search_speed * delta
		parent.rotation.y = rotate_toward(parent.rotation.y, Vector2(nav_point_direction.y, nav_point_direction.x).angle(), 5 * delta)
	elif parent.nav_agent.is_navigation_finished():
		return IdleState
	
	return null

func process(_delta) -> State:
	return null
