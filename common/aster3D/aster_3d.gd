extends CharacterBody3D

@onready var state_machine: StateMachine = $StateMachine
@onready var lantern: OmniLight3D = $OmniLight3D

func _ready() -> void:
	state_machine.init(self)
	self.add_to_group("minotarget")
	#SignalBus.escaped.connect(player_escape)
	#SignalBus.game_over.connect(lose)

func _process(delta: float) -> void:
	if not Flags.input_paused:
		state_machine.process(delta)

func _physics_process(delta: float) -> void:
	if not Flags.input_paused:
		state_machine.process_physics(delta)
		move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if not Flags.input_paused:
		state_machine.process_input(event)
		if Input.is_action_just_released("lantern_interact") and lantern.omni_range == 10.0:
			lantern.omni_range = 0.0
		elif Input.is_action_just_released("lantern_interact") and not lantern.omni_range == 10.0:
			lantern.omni_range = 10.0
