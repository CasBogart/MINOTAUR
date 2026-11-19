class_name Player extends CharacterBody2D

@onready var stateMachine: StateMachine = $StateMachine # locate state machine

func _ready() -> void:
	# add to global group so that other nodes can identify
	add_to_group("player")
	stateMachine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	# state machine offloading
	stateMachine.process_input(event)

func _physics_process(delta: float) -> void:
	# state machine offloading
	stateMachine.process_physics(delta)
	move_and_slide()

func _process(delta: float) -> void:
	# state machine offloading
	stateMachine.process(delta)
