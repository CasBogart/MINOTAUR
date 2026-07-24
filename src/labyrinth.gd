class_name labyrinth extends TileMapLayer

# map size needs to be an odd number to properly center the starting room
# have it throw error if not??

enum cell_state {UNVISITED, POSSIBLE, VISITED}
# didn't want to hardcode this but can't export it and onready it at the same time afaik
@onready var size: int = 31
@onready var cam: Camera2D = $Camera2D
@onready var dark: CanvasModulate = $CanvasModulate
@onready var fog: TileMapLayer = $Fog
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var has_exit: bool = false
var aster = preload("res://common/aster/aster.tscn")
var minotaur = preload("res://common/minotaur/minotaur.tscn")
var exit = preload("res://common/exit/exit.tscn")

func inst(pos: Vector2, object: Resource, rot: float = 0):
	var instance = object.instantiate()
	instance.position = pos
	instance.rotation = deg_to_rad(rot)
	add_child(instance)

func _ready() -> void:
	print(rng)
	if not Flags.here_before:
		while not has_exit:
			generate()
		Flags.here_before = true
	SignalBus.open_map.connect(enable_fog)
	SignalBus.close_map.connect(disable_fog)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("map"):
		if dark.visible:
			dark.visible = false
		elif not dark.visible:
			dark.visible = true
		
		if Flags.map_opened:
			Flags.map_opened = false
			SignalBus.emit_signal("close_map", cam)
		elif not Flags.map_opened:
			Flags.map_opened = true
			SignalBus.emit_signal("open_map", cam)

func _process(_delta: float) -> void:
	if fog.get_cell_atlas_coords(local_to_map(get_tree().get_first_node_in_group("minotarget").position)) == Vector2i(0, 0):
		fog.erase_cell(local_to_map(get_tree().get_first_node_in_group("minotarget").position))
	
	if Flags.input_paused:
		SignalBus.emit_signal("close_map", cam)

func generate() -> labyrinth:
	rng.seed = hash(Time.get_datetime_string_from_system(false, true))
	var map: Array = initialize_maze()
	hunt_and_kill(map)
	find_possible_exit(map)
	draw_map(map)
	spawn_objects(map)
	initialize_fog()
	
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ok now this just loads an empty screen?????
	if not has_exit:
		self.queue_free()
	
	return self

func spawn_objects(map: Array):
	#this isn't perfectly centered bc (16, 16) afaik is always a wall but. whatev
	inst(map_to_local(Vector2i(15, 15)), aster)

	if 0 < Flags.level and Flags.level < 5:
		var mino_spawn_random: Array = []
		for i in map.size():
			for j in map.size():
				# add something to make sure not too close to player
				if map[i][j] == cell_state.VISITED and check_neighbors([i, j], map, cell_state.VISITED, 1).size() == 1:
					mino_spawn_random.append([i, j])
		
		# might be better to make sure this is in a certain vicinity to the player
		# also fuckkkkkk it only generates on first entry i need to move these somewhere else
		var spawn: Array = mino_spawn_random.pick_random()
		inst(map_to_local(Vector2i(spawn[0], spawn[1])), minotaur)

func initialize_maze() -> Array:
	# initializes an array of arrays of zeroes to serve as base for map
	var maze: Array = []
	
	maze.resize(size)
	maze.fill(0)
	
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

func initialize_fog():
	for i in range(-5, size + 5):
		for j in range(-5, size + 5):
			fog.set_cell(Vector2i(i, j), 0, Vector2i(0, 0))

func random_coordinate(map_size: int) -> Array:
	# generates random coordinate exclusive of outer "ring"
	# aka first and last rows + index = 0 and index = map_size - 1
	# and also within a valid cell (odd number)
	
	return [(rng.randi_range(0, floor(map_size - 3) / 2) * 2) + 1, (rng.randi_range(0, floor(map_size - 3) / 2) * 2) + 1]

func check_neighbors(coordinates: Array, map: Array, state: int, dist: int = 2) -> Array:
	var possible_neighbors: Array = []
	
	if (1 <= coordinates[0] - dist) and (map[coordinates[0] - dist][coordinates[1]] == state):
		possible_neighbors.append([coordinates[0] - dist, coordinates[1]])
	
	if (coordinates[0] + dist <= map.size() - dist) and (map[coordinates[0] + dist][coordinates[1]] == state):
		possible_neighbors.append([coordinates[0] + dist, coordinates[1]])
	
	if (1 <= coordinates[1] - dist) and (map[coordinates[0]][coordinates[1] - dist] == state):
		possible_neighbors.append([coordinates[0], coordinates[1] - dist])
	
	if (coordinates[1] + dist <= map.size() - dist) and (map[coordinates[0]][coordinates[1] + dist] == state):
		possible_neighbors.append([coordinates[0], coordinates[1] + dist])
	
	return possible_neighbors

func hunt(map: Array) -> Array:
	for i in map.size():
		for j in map.size():
			if map[i][j] == cell_state.POSSIBLE and check_neighbors([i, j], map, cell_state.VISITED).size() > 0:
				return [i, j]
	return []

func hunt_and_kill(map: Array) -> Array:
	# always starts in the very center cell
	var center_cell: Array = [ceil(map.size() / 2), ceil(map.size() / 2)]
	var current_cell: Array = center_cell
	var hunt_active: bool = true
	
	map[center_cell[0]][center_cell[1]] = cell_state.VISITED
	
	while hunt_active:
		var possible_unvisited: Array = check_neighbors(current_cell, map, cell_state.POSSIBLE)
		if possible_unvisited.size() > 0:
			var next_cell: Array = possible_unvisited[rng.randi_range(0, possible_unvisited.size() - 1)]
			map[next_cell[0]][next_cell[1]] = cell_state.VISITED
			map[next_cell[0] + ((current_cell[0] - next_cell[0]) / 2)][next_cell[1] + ((current_cell[1] - next_cell[1]) / 2)] = cell_state.VISITED
			current_cell = next_cell
		else:
			var hunt_cell: Array = hunt(map)
			if hunt_cell.size() > 0:
				var possible_neighbors: Array = check_neighbors(hunt_cell, map, cell_state.VISITED)
				var neighbor_cell: Array = possible_neighbors[rng.randi_range(0, possible_neighbors.size() - 1)]
				map[hunt_cell[0]][hunt_cell[1]] = cell_state.VISITED
				map[hunt_cell[0] + ((neighbor_cell[0] - hunt_cell[0]) / 2)][hunt_cell[1] + ((neighbor_cell[1] - hunt_cell[1]) / 2)] = cell_state.VISITED
				current_cell = hunt_cell
			else:
				hunt_active = false
	
	return map

func find_possible_exit(map: Array):
	var possible_exit: Array = []
	
	for i in map.size():
		for j in map.size():
			if map[i][j] == cell_state.VISITED and (i == 1 or i == 29 or j == 1 or j == 29) and check_neighbors([i, j], map, cell_state.VISITED, 1).size() == 1:
				possible_exit.append([i, j])
	
	if possible_exit.size() < 1:
		return
	
	
	var exit_neighbor: Array = possible_exit[rng.randi_range(0, possible_exit.size() - 1)]
	
	if exit_neighbor[0] == 1:
		map[0][exit_neighbor[1]] = cell_state.VISITED
		inst(map_to_local(Vector2i(exit_neighbor[0], exit_neighbor[1])) - Vector2(8, -24), exit, 180)
	elif exit_neighbor[0] == 29:
		map[30][exit_neighbor[1]] = cell_state.VISITED
		inst(map_to_local(Vector2i(exit_neighbor[0], exit_neighbor[1])) - Vector2(-8, 24), exit)
	elif exit_neighbor[1] == 1:
		map[exit_neighbor[0]][0] = cell_state.VISITED
		inst(map_to_local(Vector2i(exit_neighbor[0], exit_neighbor[1])) - Vector2(24, 8), exit, 270)
	elif exit_neighbor[1] == 29:
		map[exit_neighbor[0]][30] = cell_state.VISITED
		inst(map_to_local(Vector2i(exit_neighbor[0], exit_neighbor[1])) - Vector2(-24, -8), exit, 90)
	
	has_exit = true

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

func enable_fog(_cam: Camera2D):
	fog.enabled = true

func disable_fog(_cam: Camera2D):
	fog.enabled = false
