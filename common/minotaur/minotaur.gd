extends CharacterBody2D

# tutorial for navagents by MostlyMadProductions on YT

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var lantern_raycast: RayCast2D = $LanternCast
@onready var search_area: Area2D = $SearchArea
@onready var search_timer: Timer = $SearchTimer
@onready var lantern_follow_timer: Timer = $LanternFollowTimer
@onready var state_machine: StateMachine = $StateMachine

@export var PursueState: State
@export var FollowState: State

var current_lantern_raycast_collider
var current_raycast_collider
var lantern_following: bool = false

func _ready() -> void:
	state_machine.init(self)
	SignalBus.player_running.connect(player_follow)
	SignalBus.lantern_follow.connect(lantern_follow)

func _process(delta: float) -> void:
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	raycast.target_position = (get_tree().get_first_node_in_group("minotarget").position - self.position)
	lantern_raycast.target_position = get_global_mouse_position() - self.position
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

# this is probably fucked up rn but I'll figure it out later

func _on_search_area_body_entered(_body: Node2D) -> void:
	lantern_follow_timer.start()
	search_timer.start()

func _on_search_area_body_exited(_body: Node2D) -> void:
	lantern_follow_timer.stop()
	search_timer.stop()

func _on_search_timer_timeout() -> void:
	current_raycast_collider = raycast.get_collider()
	if current_raycast_collider is CharacterBody2D and (current_raycast_collider.lantern.light.enabled == true or current_raycast_collider.velocity > Vector2(0, 0)) and not state_machine.current_state == PursueState:
		state_machine.change_state(PursueState)

func _on_lantern_follow_timer_timeout() -> void:
	current_lantern_raycast_collider = lantern_raycast.get_collider()
	if current_lantern_raycast_collider is Lantern:
		SignalBus.emit_signal("lantern_follow", get_global_mouse_position())

# these should really be the same function but idc
func player_follow(pos: Vector2):
	if not state_machine.current_state == PursueState:
		nav_agent.target_position = pos
		state_machine.change_state(FollowState)

# this gets fucked up if lantern is too close to minotaur when everything initializes, see if that can be fixed?
func lantern_follow(pos: Vector2):
	if not state_machine.current_state == PursueState:
		lantern_following = true
		nav_agent.target_position = pos
		state_machine.change_state(FollowState)
