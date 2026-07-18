class_name labyrinth extends TileMapLayer

# map size needs to be an odd number to properly center the starting room
# have it throw error if not??

enum cell_state {UNVISITED, POSSIBLE, VISITED}
# didn't want to hardcode this but can't export it and onready it at the same time afaik
@onready var size: int = 51

var aster = preload("res://common/aster/aster.tscn")

func player_inst(pos):
	var asterinst = aster.instantiate()
	asterinst.position = pos
	add_child(asterinst)

func _ready() -> void:
	generate()
	player_inst(Vector2(100, 100))

func generate() -> labyrinth:
	var map: Array = initialize_maze()
	hunt_and_kill(map)
	draw_map(map)
	return self

func initialize_maze() -> Array:
	# initializes an array of arrays of zeroes to serve as base for map
	var maze: Array = []
	
	maze.resize(size)
	maze.fill(cell_state.UNVISITED)
	
	for i in size:
		var row: Array = []
		row.resize(size)
		row.fill(cell_state.UNVISITED)
		maze[i] = row
	
	# could probably do this more efficiently but not my problem rn
	for i in size:
		for j in size:
			if i % 2 != 0 and j % 2 != 0:
				maze[i][j] = cell_state.POSSIBLE
	
	return maze

func random_coordinate(map_size: int) -> Array:
	# generates random coordinate exclusive of outer "ring"
	# aka first and last rows + index = 0 and index = map_size - 1
	# and also within a valid cell (odd number)
	
	return [(randi_range(0, floor(map_size - 3) / 2) * 2) + 1, (randi_range(0, floor(map_size - 3) / 2) * 2) + 1]

func check_neighbors(coordinates: Array, map: Array, state: int) -> Array:
	var possible_neighbors: Array = []
	
	if (1 <= coordinates[0] - 2) and (map[coordinates[0] - 2][coordinates[1]] == state):
		possible_neighbors.append([coordinates[0] - 2, coordinates[1]])
	
	if (coordinates[0] + 2 <= map.size() - 2) and (map[coordinates[0] + 2][coordinates[1]] == state):
		possible_neighbors.append([coordinates[0] + 2, coordinates[1]])
	
	if (1 <= coordinates[1] - 2) and (map[coordinates[0]][coordinates[1] - 2] == state):
		possible_neighbors.append([coordinates[0], coordinates[1] - 2])
	
	if (coordinates[1] + 2 <= map.size() - 2) and (map[coordinates[0]][coordinates[1] + 2] == state):
		possible_neighbors.append([coordinates[0], coordinates[1] + 2])
	
	return possible_neighbors

func hunt(map: Array) -> Array:
	for i in map.size():
		for j in map.size():
			if map[i][j] == cell_state.POSSIBLE and check_neighbors([i, j], map, cell_state.VISITED).size() > 0:
				return [i, j]
	return []

func hunt_and_kill(map: Array) -> Array:
	# always starts in the very center cell
	var center_cell: Array = [floor(map.size() / 2), floor(map.size() / 2)]
	var current_cell: Array = center_cell
	var hunt_active: bool = true
	
	map[center_cell[0]][center_cell[1]] = cell_state.VISITED
	
	while hunt_active:
		var possible_unvisited: Array = check_neighbors(current_cell, map, cell_state.POSSIBLE)
		if possible_unvisited.size() > 0:
			var next_cell: Array = possible_unvisited.pick_random()
			map[next_cell[0]][next_cell[1]] = cell_state.VISITED
			map[next_cell[0] + ((current_cell[0] - next_cell[0]) / 2)][next_cell[1] + ((current_cell[1] - next_cell[1]) / 2)] = cell_state.VISITED
			current_cell = next_cell
		else:
			var hunt_cell: Array = hunt(map)
			if hunt_cell.size() > 0:
				var neighbor_cell: Array = check_neighbors(hunt_cell, map, cell_state.VISITED).pick_random()
				map[hunt_cell[0]][hunt_cell[1]] = cell_state.VISITED
				map[hunt_cell[0] + ((neighbor_cell[0] - hunt_cell[0]) / 2)][hunt_cell[1] + ((neighbor_cell[1] - hunt_cell[1]) / 2)] = cell_state.VISITED
				current_cell = hunt_cell
			else:
				hunt_active = false
	
	return map

func draw_map(map: Array):
	for i in map.size():
		for j in map.size():
			match map[i][j]:
				cell_state.UNVISITED:
					self.set_cell(Vector2i(i, j), 0, Vector2i(0, 0))
				cell_state.POSSIBLE:
					self.set_cell(Vector2i(i, j), 0, Vector2i(1, 0))
				cell_state.VISITED:
					self.set_cell(Vector2i(i, j), 0, Vector2i(2, 0))
	return
