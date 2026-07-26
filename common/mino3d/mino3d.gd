class_name Mino3D extends CharacterBody3D

@onready var state_machine: StateMachine = $mino/StateMachine
@onready var anim_player: AnimationPlayer = $mino/AnimationPlayer
@onready var nav_agent: NavigationAgent3D = $mino/NavigationAgent3D

func _ready() -> void:
	state_machine.init(self)
	SignalBus.player_running.connect(player_follow)

func _process(delta: float) -> void:
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func player_follow(_pos: Vector3):
	pass
