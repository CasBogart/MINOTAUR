class_name Lantern extends Node2D

@onready var light: PointLight2D = $PointLight2D
@onready var area: Area2D = $Area2D
@onready var lantern_timer: Timer = $Timer
var light_has_been_disabled: bool = true
var num: int = 0

func _ready() -> void:
	if Flags.level < 5 and Flags.level > 1:
		light.texture_scale = 1.5
	SignalBus.open_map.connect(hide_lantern)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("lantern_interact") and not light.enabled:
		light.enabled = true
	elif Input.is_action_just_released("lantern_interact") and light.enabled:
		light_has_been_disabled = true
		light.enabled = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if lantern_timer.is_stopped() and light_has_been_disabled and Flags.map_opened == false:
		# FUCK YOUUUUUUUUU
		SignalBus.emit_signal("lantern_follow", get_global_mouse_position())
		# delay timer until next time minotaur can be lured
		lantern_timer.start(15 + (randf_range(5, 10) * num))
		# increase time between lures
		num += 1
		light_has_been_disabled = false

func hide_lantern(_cam: Camera2D):
	if self.visible:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		self.visible = false
		area.monitorable = false
		area.monitoring = false
		light.energy = 0
	elif not self.visible:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		self.visible = true
		area.monitorable = true
		area.monitoring = true
		light.energy = 1
