extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var player_cam: Camera2D = $PlayerCam
@onready var lantern: PointLight2D = $Lantern
@onready var color: ColorRect = $ColorRect
@onready var dist: Label = $Gui2/Control/ColorRect/Label
@onready var ui_timer: Timer = $"UI Timer"

@onready var gui1: CanvasLayer = $Gui
@onready var gui2: CanvasLayer = $Gui2

var total_distance = 0

# i just made some bullshittttt

func _ready() -> void:
	if Flags.level >= 2:
		lantern.texture_scale = 0.5
	state_machine.init(self)
	self.add_to_group("minotarget")
	SignalBus.escaped.connect(player_escape)
	SignalBus.game_over.connect(lose)
	
	# this is convoluted but makes sure the character is facing south when you load in
	animated_sprite.play("walkforward")
	animated_sprite.set_frame(1)
	color.color.a = 0
	
	dist.text = str(int(floor((self.position - Flags.exit_coords).length())))

func _process(delta: float) -> void:
	if not Flags.input_paused:
		state_machine.process(delta)
	
	if ui_timer.timeout:
		update_dist()

func _physics_process(delta: float) -> void:
	if not Flags.input_paused:
		state_machine.process_physics(delta)
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if not Flags.input_paused:
		state_machine.process_input(event)
		if Input.is_action_just_released("lantern_interact") and lantern.enabled:
			lantern.enabled = false
		elif Input.is_action_just_released("lantern_interact") and not lantern.enabled:
			lantern.enabled = true

func player_escape():
	gui1.hide()
	gui2.hide()
	var tween = get_tree().create_tween()
	await tween.tween_property(color, "color:a", 1.0, 2.0).finished

func update_dist():
	total_distance = int(floor((self.position - Flags.exit_coords).length()))
	dist.text = str(total_distance)

func lose():
	velocity = Vector2(0, 0)
	Flags.input_paused = true
	gui1.hide()
	gui2.hide()
	var tween = get_tree().create_tween()
	await tween.tween_property(color, "color:a", 1.0, 2.0).finished
