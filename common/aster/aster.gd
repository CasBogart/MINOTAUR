extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var player_cam: Camera2D = $PlayerCam
@onready var color: ColorRect = $ColorRect

@export var lantern: Lantern

# i just made some bullshittttt

func _ready() -> void:
	state_machine.init(self)
	self.add_to_group("minotarget")
	SignalBus.open_map.connect(map_open)
	SignalBus.close_map.connect(map_close)
	SignalBus.escaped.connect(player_escape)
	
	# this is convoluted but makes sure the character is facing south when you load in
	animated_sprite.play("walkforward")
	animated_sprite.set_frame(1)
	color.color.a = 0

func _process(delta: float) -> void:
	if not Flags.input_paused:
		state_machine.process(delta)
		# there's some latency but whatever atp
		lantern.position = get_global_mouse_position() - self.position

func _physics_process(delta: float) -> void:
	if not Flags.input_paused:
		state_machine.process_physics(delta)
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if not Flags.input_paused:
		state_machine.process_input(event)

func map_open(camera: Camera2D):
	if not camera.enabled and not Flags.input_paused:
		Flags.map_opened = true
		camera.enabled = true
		player_cam.enabled = false

func map_close(camera: Camera2D):
	if camera.enabled:
		Flags.map_opened = false
		player_cam.enabled = true
		camera.enabled = false

func player_escape():
	print("FUCKKKKKKK")
	var tween = get_tree().create_tween()
	await tween.tween_property(color, "color:a", 1.0, 2.0).finished
