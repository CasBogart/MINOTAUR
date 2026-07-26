extends Node3D

var aster3D = preload("res://common/aster3D/aster3D.tscn")

func inst(pos: Vector3, object: Resource, rot = 0):
	var instance = object.instantiate()
	# no clue why this is half throwing an error??
	instance.set_global_position.call_deferred(pos)
	instance.set_global_rotation.call_deferred(rot)
	add_child(instance)

func _ready():
	inst(Vector3(0, 0, 0), aster3D, Vector3(0, 0, 0))
