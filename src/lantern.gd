class_name Lantern extends Node2D

@onready var light: PointLight2D = $PointLight2D
@onready var lantern_timer: Timer = $Timer
var light_has_been_disabled: bool = true
var num: int = 0

func _ready() -> void:
	if Flags.level < 5 and Flags.level > 1:
		light.texture_scale = 1.5
	SignalBus.open_map.connect(hide_lantern)
	SignalBus.close_map.connect(show_lantern)

func _input(_event: InputEvent) -> void:
	if not Flags.map_opened:
		if Input.is_action_just_released("lantern_interact") and not light.enabled:
			light.enabled = true
		elif Input.is_action_just_released("lantern_interact") and light.enabled:
			light_has_been_disabled = true
			light.enabled = false

func hide_lantern(_cam: Camera2D):
	self.visible = false
	self.monitoring = false
	self.monitorable = false
	light.enabled = false

func show_lantern(_cam: Camera2D):
	self.visible = true
	self.monitoring = true
	self.monitorable = true
	light.enabled = true
