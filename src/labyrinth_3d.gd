class_name labyrinth3D extends Node3D

# define cardinal directions
enum direction {N, E, S, W}
# preload cell
var cell = preload("res://src/tile3D/tile3D.tscn")

# store map data locally
var local_data: Array

func inst(pos: Vector3, object: Resource, rot: float = 0):
	# instantiate given object to specified position and rotation
	var instance = object.instantiate()
	instance.position = pos
	instance.rotation = deg_to_rad(rot)
	add_child(instance)

func _ready():
	# if maze data has been saved previously
	if Flags.maze_data:
		# update locally
		local_data = Flags.maze_data
		for i in local_data:
			for j in i:
				# if cell = cell_state.VISITED
				# ^ can't access from here but this works also
				if j == 2:
					# instantiate a cell at that location
					pass
