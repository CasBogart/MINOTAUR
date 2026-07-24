extends TileMapLayer

@onready var exit_collider: Area2D = $Area2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("minotarget"):
		print("escaped!!!")
