extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var player_cam: Camera2D = $Camera2D
@onready var lantern = $Lantern

# i just made some bullshittttt

func _ready() -> void:
	state_machine.init(self)
	self.add_to_group("minotarget")
	SignalBus.open_map.connect(map_open)
	
	# this is convoluted but makes sure the character is facing south when you load in
	animated_sprite.play("walkforward")
	animated_sprite.set_frame(1)

func _process(delta: float) -> void:
	state_machine.process(delta)
	# there's some latency but whatever atp
	lantern.position = get_global_mouse_position() - self.position

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func map_open(camera: Camera2D):
	if not camera.enabled:
		camera.enabled = true
		player_cam.enabled = false
	else:
		player_cam.enabled = true
		camera.enabled = false
