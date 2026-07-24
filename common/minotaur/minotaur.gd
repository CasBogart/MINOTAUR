extends CharacterBody2D

# tutorial for navagents by MostlyMadProductions on YT

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var lantern_raycast: RayCast2D = $LanternCast
@onready var search_area: Area2D = $SearchArea
@onready var search_timer: Timer = $SearchTimer
@onready var distract_timer: Timer = $DistractTimer
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D

@export var PursueState: State
@export var FollowState: State

var current_lantern_raycast_collider
var current_raycast_collider
var lantern_following: bool = false

func _ready() -> void:
	state_machine.init(self)
	SignalBus.player_running.connect(player_follow)
	SignalBus.lantern_follow.connect(lantern_follow)
	SignalBus.open_map.connect(hide_sprite)
	SignalBus.close_map.connect(show_sprite)
	search_timer.start()

func _process(delta: float) -> void:
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	raycast.target_position = (get_tree().get_first_node_in_group("minotarget").position - self.position)
	lantern_raycast.target_position = get_global_mouse_position() - self.position
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
#
func _on_search_timer_timeout() -> void:
	current_raycast_collider = raycast.get_collider()
	current_lantern_raycast_collider = lantern_raycast.get_collider()
	
	if current_raycast_collider is CharacterBody2D and (current_raycast_collider.lantern.light.enabled or current_raycast_collider.velocity > Vector2(0, 0)) and not state_machine.current_state == PursueState:
		state_machine.change_state(PursueState)
	elif current_lantern_raycast_collider is Lantern and current_lantern_raycast_collider.light.enabled and not Flags.mino_distracted:
		lantern_following = true
		SignalBus.emit_signal("lantern_follow", current_lantern_raycast_collider.position)

# make sure this works
func _on_distract_timer_timeout() -> void:
	Flags.mino_distracted = false

## these should really be the same function but idc
func player_follow(pos: Vector2):
	if not state_machine.current_state == PursueState and not state_machine.current_state == FollowState:
		nav_agent.target_position = pos
		state_machine.change_state(FollowState)
	elif not state_machine.current_state == PursueState:
		nav_agent.target_position = pos

func lantern_follow(pos: Vector2):
	if not state_machine.current_state == PursueState and not state_machine.current_state == FollowState:
		nav_agent.target_position = pos
		state_machine.change_state(FollowState)
	elif not state_machine.current_state == PursueState:
		nav_agent.target_position = pos

func hide_sprite(_cam: Camera2D):
	sprite.visible = false

func show_sprite(_cam: Camera2D):
	sprite.visible = true
