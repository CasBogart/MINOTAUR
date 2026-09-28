extends TileMapLayer

@onready var exit_collider: Area2D = $Area2D

# tile resource needs to rotate if on N or S side :[

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("minotarget"):
		Flags.input_paused = true
		SignalBus.emit_signal("escaped")
