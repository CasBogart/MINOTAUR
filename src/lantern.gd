class_name Lantern extends Node2D

@onready var light: PointLight2D = $PointLight2D
@onready var lantern_timer: Timer = $Timer
var num: int = 0

func _ready() -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("lantern_interact") and not light.enabled:
		light.enabled = true
	elif Input.is_action_just_released("lantern_interact") and light.enabled:
		light.enabled = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if lantern_timer.is_stopped():
		SignalBus.emit_signal("lantern_follow", get_global_mouse_position())
		# delay timer until next time minotaur can be lured
		lantern_timer.start(20 + (randf_range(5, 20) * num))
		# increase time between lures
		num += 1
