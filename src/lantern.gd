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
			light.visible = true
			light.enabled = true
		elif Input.is_action_just_released("lantern_interact") and light.enabled:
			light_has_been_disabled = true
			light.visible = false
			light.enabled = false

func hide_lantern(_cam: Camera2D):
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	self.visible = false
	self.monitoring = false
	self.monitorable = false

# don't automatically turn on 
func show_lantern(_cam: Camera2D):
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	self.visible = true
	self.monitoring = true
	self.monitorable = true
