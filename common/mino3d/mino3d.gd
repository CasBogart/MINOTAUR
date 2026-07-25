class_name Mino3D extends Node3D

@onready var state_machine: StateMachine = $StateMachine
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var velocity = Vector3(0, 0, 0)

func _ready() -> void:
	state_machine.init(self)
	SignalBus.player_running.connect(player_follow)

func player_follow(_pos: Vector3):
	pass
