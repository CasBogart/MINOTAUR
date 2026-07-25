extends CharacterBody2D

# tutorial for navagents by MostlyMadProductions on YT

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var search_area: Area2D = $SearchArea
@onready var search_timer: Timer = $SearchTimer
@onready var distract_timer: Timer = $DistractTimer
@onready var follow_timer: Timer = $StateMachine/FollowTimer
@onready var state_machine: StateMachine = $StateMachine
@onready var collider: Area2D = $DeadEndCollider

@export var PursueState: State
@export var FollowState: State

var current_raycast_collider

func _ready() -> void:
	state_machine.init(self)
	SignalBus.player_running.connect(player_follow)
	search_timer.start()

func _process(delta: float) -> void:
	state_machine.process(delta)
	
	if not state_machine.current_state == PursueState or (state_machine.current_state == FollowState and not nav_agent.target_position == get_tree().get_first_node_in_group("minotarget").position):
		collider.monitoring = false
	else:
		collider.monitoring = true

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	raycast.target_position = (get_tree().get_first_node_in_group("minotarget").position - self.position)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
#
func _on_search_timer_timeout() -> void:
	current_raycast_collider = raycast.get_collider()
	
	if current_raycast_collider is CharacterBody2D and (current_raycast_collider.lantern.enabled or current_raycast_collider.velocity > Vector2(0, 0)) and not state_machine.current_state == PursueState and ((current_raycast_collider.position - self.position).length() < 100):
		state_machine.change_state(PursueState)

# make sure this works
func _on_distract_timer_timeout() -> void:
	Flags.mino_distracted = false

func _on_follow_timer_timeout() -> void:
	if Flags.player_run_state:
		nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").position

func player_follow(pos: Vector2):
	follow_timer.start()
	if not state_machine.current_state == PursueState and not state_machine.current_state == FollowState:
		state_machine.change_state(FollowState)
	nav_agent.target_position = pos

func _on_dead_end_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("minotarget"):
		SignalBus.emit_signal("game_over")
