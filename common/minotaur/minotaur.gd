extends CharacterBody2D

# tutorial for navagents by MostlyMadProductions on YT
# FUCKKKKKK I MIGHT HAVE TO DO A STATE MACHINE UGHHHHHHHHHH

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").position

func _physics_process(delta: float) -> void:
	if !nav_agent.is_target_reached():
		var nav_point_direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = nav_point_direction * 1000 * delta
		
		move_and_slide()

func wander():
	pass

func search_area():
	pass

func pursue():
	pass
	#nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").position
