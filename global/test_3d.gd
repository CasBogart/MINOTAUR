extends Node3D

var mino3D = preload("res://common/mino3d/mino3d.tscn")

func inst(pos: Vector3, object: Resource, rot = 0):
	var instance = object.instantiate()
	# no clue why this is half throwing an error??
	instance.set_global_position(pos)
	instance.set_global_rotation(rot)
	add_child(instance)

func _ready():
	inst(Vector3(0, 0, 0), mino3D, Vector3(0, 0, 0))
