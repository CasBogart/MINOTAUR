extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine

# i just made some bullshittttt

func _ready() -> void:
	state_machine.init(self)
	self.add_to_group("minotarget")
	
	# this is convoluted but makes sure the character is facing south when you load in
	animated_sprite.play("walkforward")
	animated_sprite.set_frame(1)

func _process(delta: float) -> void:
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
