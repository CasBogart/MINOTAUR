class_name labyrinth extends TileMapLayer

# map size needs to be an odd number + (size-1)/2 needs to also be odd to properly center the starting room
# have it throw error if not??

# cell state possibilities
enum cell_state {UNVISITED, POSSIBLE, VISITED}

# onready size of the map and rng value
# didn't want to hardcode this but can't export it and onready it at the same time afaik
@onready var size: int = 19
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# for loading, check to see when exit has been added
var has_exit: bool = false

# preloads
var aster = preload("res://common/aster/aster.tscn")
var minotaur = preload("res://common/minotaur/minotaur.tscn")
var exit = preload("res://common/exit/exit.tscn")

func inst(pos: Vector2, object: Resource, rot: float = 0):
	# instantiate given object to specified position and rotation
	var instance = object.instantiate()
	instance.position = pos
	instance.rotation = deg_to_rad(rot)
	add_child(instance)

func _ready() -> void:
	# checks if there's already map data
	if not Flags.here_before:
		# if not
		while not has_exit:
			# regenerate map if there's no given exit
			# not the most efficient, but with how small the map is should be fine
			generate()
		# save map data
		Flags.here_before = true
	
	# add objects and tile data
	spawn_objects(self)
	add_tiles(self)

func generate() -> labyrinth:
	# get the rng hash based on current time
	rng.seed = hash(Time.get_datetime_string_from_system(false, true))
	# for debug purposes
	print(rng)
	# start map initialization
	var map: Array = initialize_maze()
	# draw the maze as an array, place an exit, draw the map
	hunt_and_kill(map)
	find_possible_exit(map)
	Flags.maze_data = map
	draw_map(map)
	
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ok now this just loads an empty screen sometimes?????
	if not has_exit:
		self.queue_free()
	
	return self

func spawn_objects(map: labyrinth):
	# spawn player close to center
	# this isn't perfectly centered bc (9, 9) afaik is always a wall but. whatever
	inst(map_to_local(Vector2i(9, 9)), aster)
	
# this many nested conditionals is really good for the computer
	var mino_spawn_random: Array = []
	# for each cell in the map
	for i in size:
		for j in size:
			# check to see if it's a valid cell and if it's not too close to center
			if map.get_cell_atlas_coords(Vector2(i, j)) == Vector2i(2, 0) and (i <= 5 or i >= 13 or j <= 5 or j >= 13):
				var surrounding: Array = []
				# check surrounding cells and add them if they're also valid
				for cell in map.get_surrounding_cells(Vector2(i, j)):
					if get_cell_atlas_coords(cell) == Vector2i(2, 0):
						surrounding.append(cell)
				# if there's only one valid surrounding cell, ie if it's a dead end corridor
				if surrounding.size() == 1:
					# add to actual minotaur spawn options
					mino_spawn_random.append([i, j])
	
	# pick one of these random locations and add mino
	# also fuckkkkkk it only generates on first entry i need to move these somewhere else
	var spawn: Array = mino_spawn_random.pick_random()
	inst(map_to_local(Vector2i(spawn[0], spawn[1])), minotaur)

func initialize_maze() -> Array:
	# initializes an array of arrays of zeroes to serve as base for map
	var maze: Array = []
	maze.resize(size)
	maze.fill(0)
	
	# add a row of unvisited cells for i in size, replaces the 0s that were added earlier
	for i in size:
		var row: Array = []
		row.resize(size)
		row.fill(cell_state.UNVISITED)
		maze[i] = row
	
	# mark each possible cell by getting only the odd rows and columns, results in checkerboard sort of pattern
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
	
	return [(rng.randi_range(0, floor(map_size - 3) / 2) * 2) + 1, (rng.randi_range(0, floor(map_size - 3) / 2) * 2) + 1]

func check_neighbors(coordinates: Array, map: Array, state: int, dist: int = 2) -> Array:
	# checks any given cell to determine the state of its neighbors within a certain distance
	# basically get_surrounding_cells but with any possible offset
	# couldn't do this with match statements because it would find one possible neighbor and. move on
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
	# for each row and column
	for i in map.size():
		for j in map.size():
			# if the cell state is possible and there are possible neighbors within 2 cells
			if map[i][j] == cell_state.POSSIBLE and check_neighbors([i, j], map, cell_state.VISITED).size() > 0:
				# return that cell
				return [i, j]
	# or, return nothing
	return []

func hunt_and_kill(map: Array) -> Array:
	# always starts in the very center cell
	# or as close as I can get
	var center_cell: Array = [ceil(map.size() / 2), ceil(map.size() / 2)]
	var current_cell: Array = center_cell
	# whether or not another valid cell should be searched for
	var hunt_active: bool = true
	
	# mark center as visited
	map[center_cell[0]][center_cell[1]] = cell_state.VISITED
	
	while hunt_active:
		# find possible moves from current cell
		var possible_unvisited: Array = check_neighbors(current_cell, map, cell_state.POSSIBLE)
		# if there are some
		if possible_unvisited.size() > 0:
			# pick one at random and mark as visited
			var next_cell: Array = possible_unvisited[rng.randi_range(0, possible_unvisited.size() - 1)]
			map[next_cell[0]][next_cell[1]] = cell_state.VISITED
			# mark the cell between the two as visited
			map[next_cell[0] + ((current_cell[0] - next_cell[0]) / 2)][next_cell[1] + ((current_cell[1] - next_cell[1]) / 2)] = cell_state.VISITED
			# update current cell
			current_cell = next_cell
		# if there aren't any
		else:
			# start hunting
			var hunt_cell: Array = hunt(map)
			# if another valid cell can be found
			if hunt_cell.size() > 0:
				# do the same thing as above but with the selected hunt cell
				var possible_neighbors: Array = check_neighbors(hunt_cell, map, cell_state.VISITED)
				var neighbor_cell: Array = possible_neighbors[rng.randi_range(0, possible_neighbors.size() - 1)]
				map[hunt_cell[0]][hunt_cell[1]] = cell_state.VISITED
				map[hunt_cell[0] + ((neighbor_cell[0] - hunt_cell[0]) / 2)][hunt_cell[1] + ((neighbor_cell[1] - hunt_cell[1]) / 2)] = cell_state.VISITED
				current_cell = hunt_cell
			# if another valid cell can't be found, ie if the map has been completed
			else:
				# finish hunting, leave this while statement
				hunt_active = false
	
	return map

func find_possible_exit(map: Array):
	var possible_exit: Array = []
	
	# for each row and column in the map
	for i in map.size():
		for j in map.size():
			# if a cell has been visited and is right on the edge of the map and is otherwise a dead end
			if map[i][j] == cell_state.VISITED and (i == 1 or i == 17 or j == 1 or j == 17) and check_neighbors([i, j], map, cell_state.VISITED, 1).size() == 1:
				# add to list of possible exits
				possible_exit.append([i, j])
	
	# if there's no valid spots, return without adding an exit and rerun map gen alogrithm
	if possible_exit.size() < 1:
		return
	
	# randomly select one of the valid spots to place the exit
	var exit_neighbor: Array = possible_exit[rng.randi_range(0, possible_exit.size() - 1)]
	
	# ok I'll explain what's going on here for each, the process is the same for every case
	# first of all, this very first if/elif/elif/elif checks which side of the map the exit is going to be placed on
	if exit_neighbor[0] == 1:
		# after that's figured out, it sets whichever wall would lead to the exit to visited, ie map[x][exit_neighbor[y]] or whatever
		# this wall is on the outer ring which is why I only need to check the exit neighbor for one coordinate, the other is either 18 or 0
		map[0][exit_neighbor[1]] = cell_state.VISITED
		# then, it adds the exit preload with some rotation and offset: the offset is to account for the size of the exit hallway itself
		# and the rotation is so that it's actually able to be reached from the newly destroyed wall
		inst(map_to_local(Vector2i(exit_neighbor[0], exit_neighbor[1])) - Vector2(8, -24), exit, 180)
		# finally, the coordinates of the exit are added to a global flag to control the countdown
		Flags.exit_coords = map_to_local(Vector2i(0, exit_neighbor[1]))
	elif exit_neighbor[0] == 17:
		map[18][exit_neighbor[1]] = cell_state.VISITED
		inst(map_to_local(Vector2i(exit_neighbor[0], exit_neighbor[1])) - Vector2(-8, 24), exit)
		Flags.exit_coords = map_to_local(Vector2i(30, exit_neighbor[1]))
	elif exit_neighbor[1] == 1:
		map[exit_neighbor[0]][0] = cell_state.VISITED
		inst(map_to_local(Vector2i(exit_neighbor[0], exit_neighbor[1])) - Vector2(24, 8), exit, 270)
		Flags.exit_coords = map_to_local(Vector2i(exit_neighbor[0], 0))
	elif exit_neighbor[1] == 17:
		map[exit_neighbor[0]][18] = cell_state.VISITED
		inst(map_to_local(Vector2i(exit_neighbor[0], exit_neighbor[1])) - Vector2(-24, -8), exit, 90)
		Flags.exit_coords = map_to_local(Vector2i(exit_neighbor[0], 30))
	
	# has_exit is updated so that we don't have to regenerate the map at all
	has_exit = true

func draw_map(map: Array):
	# for each cell in the map
	for i in map.size():
		for j in map.size():
			# match the cell to its state and draw each as the appropriate tile
			match map[i][j]:
				cell_state.UNVISITED:
					self.set_cell(Vector2i(i, j), 0, Vector2i(0, 0))
				cell_state.POSSIBLE:
					self.set_cell(Vector2i(i, j), 0, Vector2i(1, 0))
				cell_state.VISITED:
					self.set_cell(Vector2i(i, j), 0, Vector2i(2, 0))

func add_tiles(map: labyrinth):
	# this had to be set as a separate function, because the black/gray/white tiles are meant for just loading everything in
	# and the mino spawn kinda freaks out bc it's a different tileset and indexes differently from everything else
	# ie I try to look for valid locations but the tile I need is Vector2i(2, 0) and it's only finding Vector21(0, 0) from a different tileset
	for i in size:
		for j in size:
			# anyway just update all valid cells to the correct tileset
			if map.get_cell_atlas_coords(Vector2(i, j)) == Vector2i(2, 0):
				self.set_cell(Vector2i(i, j), 1, Vector2i(0, 0))
