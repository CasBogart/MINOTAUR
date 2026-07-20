extends CharacterBody2D

# tutorial for navagents by MostlyMadProductions on YT

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var search_area: Area2D = $SearchArea
@onready var search_timer: Timer = $SearchTimer
@onready var state_machine: StateMachine = $StateMachine
var current_raycast_collider

func _ready() -> void:
	state_machine.init(self)
	SignalBus.player_running.connect(update_search)

func _process(delta: float) -> void:
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	raycast.target_position = (get_tree().get_first_node_in_group("minotarget").position - self.position)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _on_search_area_body_entered(_body: Node2D) -> void:
	search_timer.start()

func _on_search_area_body_exited(_body: Node2D) -> void:
	search_timer.stop()

func _on_search_timer_timeout() -> void:
	current_raycast_collider = raycast.get_collider()
	if current_raycast_collider is CharacterBody2D:
		search_timer.stop()
		state_machine.change_state($StateMachine/MinoPursue)

func update_search(pos: Vector2i):
	if not state_machine.current_state == $StateMachine/MinoFollow:
		state_machine.change_state($StateMachine/MinoFollow)
	
	nav_agent.target_position = pos
