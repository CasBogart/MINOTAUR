extends CharacterBody2D

# tutorial for navagents by MostlyMadProductions on YT

# nav agent for handling navigation
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
# raycast to check player position
@onready var raycast: RayCast2D = $RayCast2D
# timer to update raycast collider
@onready var search_timer: Timer = $SearchTimer
# minotaur can be distracted, determines how long it'll happen for
@onready var distract_timer: Timer = $DistractTimer
# update follow location when player is running
@onready var follow_timer: Timer = $StateMachine/FollowTimer
# state machine
@onready var state_machine: StateMachine = $StateMachine
# game over collider
@onready var collider: Area2D = $DeadEndCollider

# export states that are associated with force changes
@export var PursueState: State
@export var FollowState: State

# for updating current raycast collider
var current_raycast_collider

func _ready() -> void:
	# initialize state machine
	state_machine.init(self)
	# connect player running signal to the player_follow funciton
	SignalBus.player_running.connect(player_follow)
	# start search timer to constantly update raycast
	search_timer.start()

func _process(delta: float) -> void:
	state_machine.process(delta)
	
	# turn off monitoring for game over if not pursuing OR if following but player is in different position
	if not state_machine.current_state == PursueState or (state_machine.current_state == FollowState and not nav_agent.target_position == get_tree().get_first_node_in_group("minotarget").position):
		collider.monitoring = false
	else:
		collider.monitoring = true

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	# constantly keep raycast targeted towards player
	raycast.target_position = (get_tree().get_first_node_in_group("minotarget").position - self.position)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
#
func _on_search_timer_timeout() -> void:
	# update collider on timeout
	current_raycast_collider = raycast.get_collider()
	
	# start pursuit if colliding with player and player is close enough and either lantern is on or player is moving
	if current_raycast_collider is CharacterBody2D and (current_raycast_collider.lantern.enabled or current_raycast_collider.velocity > Vector2(0, 0)) and not state_machine.current_state == PursueState and ((current_raycast_collider.position - self.position).length() < 100):
		state_machine.change_state(PursueState)

# make sure this works
func _on_distract_timer_timeout() -> void:
	Flags.mino_distracted = false

func _on_follow_timer_timeout() -> void:
	# as long as player is running
	if Flags.player_run_state:
		# update follow position as long as flag is raised
		nav_agent.target_position = get_tree().get_first_node_in_group("minotarget").position
	else:
		follow_timer.stop()

func player_follow(pos: Vector2):
	# change to follow state as long as not pursuing
	if not state_machine.current_state == PursueState and not state_machine.current_state == FollowState:
		state_machine.change_state(FollowState)
		# start follow timer
		follow_timer.start()
		# initial nav agent update
		nav_agent.target_position = pos

func _on_dead_end_collider_body_entered(body: Node2D) -> void:
	# if player collides with mino, game over
	if body.is_in_group("minotarget"):
		SignalBus.emit_signal("game_over")
