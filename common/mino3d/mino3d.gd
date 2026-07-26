class_name Mino3D extends CharacterBody3D

@onready var state_machine: StateMachine = $mino/StateMachine
@onready var anim_player: AnimationPlayer = $mino/AnimationPlayer
@onready var nav_agent: NavigationAgent3D = $mino/NavigationAgent3D
@onready var raycast: RayCast3D = $RayCast3D
@onready var collider: Area3D = $Area3D
@onready var search_timer: Timer = $SearchTimer
@onready var distract_timer: Timer = $DistractTimer
@onready var follow_timer: Timer = $mino/StateMachine/FollowTimer

@export var PursueState: State
@export var FollowState: State

var current_raycast_collider

func _ready() -> void:
	state_machine.init(self)
	SignalBus.player_running_3D.connect(player_follow_3D)

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

func _on_search_timer_timeout() -> void:
	current_raycast_collider = raycast.get_collider()
	
	if current_raycast_collider is CharacterBody3D and (current_raycast_collider.lantern.enabled or current_raycast_collider.velocity > Vector2(0, 0)) and not state_machine.current_state == PursueState and ((current_raycast_collider.position - self.position).length() < 100):
		state_machine.change_state(PursueState)

func _on_distract_timer_timeout() -> void:
	Flags.mino_distracted = false

func _on_follow_timer_timeout() -> void:
	if Flags.player_run_state:
		nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").global_position

func player_follow_3D(pos: Vector3):
	follow_timer.start()
	if not state_machine.current_state == PursueState and not state_machine.current_state == FollowState:
		state_machine.change_state(FollowState)
	nav_agent.target_position = Vector3(pos.x, 0, pos.z) - self.position

# still need gameover
