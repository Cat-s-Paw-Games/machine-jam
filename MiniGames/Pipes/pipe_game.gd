extends Node2D

const PIPE = preload("uid://bwj5jx5v4ljiw")
@export var grid_size : Vector2i = Vector2i(6, 6)
@export var cell_size : int = 128

@onready var canvas: Node2D = %Canvas

var grid = []
var start_cell = Vector2i(0,0)
var end_cell = Vector2i(grid_size.y - 1, grid_size.x - 1)

func _ready():
	generate_grid()
	#start_cell = grid[0][0]
	#end_cell = grid[grid_size.y -1][grid_size.x - 1]

func generate_grid():
	var level = generate_level()
	var _grid = level["grid"]

	# clear old grid if needed
	for y in range(grid.size()):
		for x in range(grid[y].size()):
			if grid[y][x] != null:
				grid[y][x].queue_free()

	grid.clear()

	for y in range(grid_size.y):
		grid.append([])

		for x in range(grid_size.x):
			var pos = Vector2i(x, y)

			var pipe = PIPE.instantiate()
			pipe.position = Vector2(x, y) * cell_size

			var connections = _grid[pos]

			canvas.add_child(pipe)
			pipe.set_connections(connections)


			pipe.pipe_rotated.connect(flow_from)

			grid[y].append(pipe)

func random_pipe():
	var roll = randi() % 100
	var picked = []
	
	if roll < 40:
		picked = [[0,2], [1,3]].pick_random() # straight (common)
	
	elif roll < 70:
		picked = [
			[0,1],[1,2],[2,3],[3,0]
		].pick_random() # corners
	
	elif roll < 90:
		picked = [
			[0,1,2],[1,2,3],[2,3,0],[3,0,1]
		].pick_random() # T pipes
	
	else:
		picked = [0,1,2,3] # cross (rare)
	
	return picked


func flow_from():
	var visited = {}
	var stack = [start_cell]

	while stack.size() > 0:
		var current_pos = stack.pop_back()

		if visited.has(current_pos):
			continue

		visited[current_pos] = true

		var current_pipe = grid[current_pos.y][current_pos.x]

		for dir in current_pipe.connections:
			var neighbor_pos = current_pos + dir_to_vector(dir)

			if not is_inside_grid(neighbor_pos):
				continue
			if visited.has(neighbor_pos):
				continue

			var neighbor_pipe = grid[neighbor_pos.y][neighbor_pos.x]

			if neighbor_pipe == null:
				continue

			# MUST match opposite direction
			if opposite(dir) in neighbor_pipe.connections:
				stack.append(neighbor_pos)

	print(visited)
	if visited.has(end_cell):
		print("WIN")

func is_inside_grid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.y >= 0 \
		and pos.x < grid_size.x \
		and pos.y < grid_size.y


func dir_to_vector(dir: int):
	match dir:
		0: return Vector2i(0, -1) # UP
		1: return Vector2i(1, 0)  # RIGHT
		2: return Vector2i(0, 1)  # DOWN
		3: return Vector2i(-1, 0) # LEFT
	return Vector2i.ZERO

func opposite(dir: int) -> int:
	match dir:
		0: return 2 # UP -> DOWN
		1: return 3 # RIGHT -> LEFT
		2: return 0 # DOWN -> UP
		3: return 1 # LEFT -> RIGHT
	return -1

func generate_path() -> Array:
	var path = [start_cell]
	var current = start_cell
	var visited = {}
	visited[start_cell] = true

	while current != end_cell:
		var neighbors = []

		for dir in range(4):
			var next = current + dir_to_vector(dir)

			if not is_inside_grid(next):
				continue
			if visited.has(next):
				continue

			neighbors.append(next)

		if neighbors.is_empty():
			return generate_path()

		current = neighbors.pick_random()
		path.append(current)
		visited[current] = true

	return path

func path_to_pipes(path: Array) -> Dictionary:
	var pipes = {}

	for i in range(path.size()):
		var pos = path[i]

		if !pipes.has(pos):
			pipes[pos] = []

		# incoming connection
		if i > 0:
			var from = path[i - 1]
			var dir = dir_to_index(path[i] - from)

			pipes[pos].append(dir)

			if !pipes.has(from):
				pipes[from] = []

			pipes[from].append(opposite(dir))

		# outgoing connection
		if i < path.size() - 1:
			var dir2 = dir_to_index(path[i + 1] - path[i])
			pipes[pos].append(dir2)

	# cleanup duplicates (Godot-safe, no helpers)
	for p in pipes.keys():
		var cleaned = []
		for v in pipes[p]:
			if v not in cleaned:
				cleaned.append(v)
		pipes[p] = cleaned
		pipes[p].sort()

	var pipeoptions = [
		[0,2], # straight vertical
		[1,3], # straight horizontal
		[0,1], # corner
		[1,2],
		[2,3],
		[3,0],
		[0,1,2], # T
		[1,2,3],
		[2,3,0],
		[3,0,1],
		[0,1,2,3] # cross
	]
	
	var start = path[0]
	var end = path[path.size() - 1]

	pipes[start] = pipeoptions.pick_random()
	pipes[end] = pipeoptions.pick_random()

	return pipes

func dir_to_index(diff: Vector2i) -> int:
	if diff == Vector2i(0, -1): return 0
	if diff == Vector2i(1, 0): return 1
	if diff == Vector2i(0, 1): return 2
	if diff == Vector2i(-1, 0): return 3
	return -1

func fill_grid(solution: Dictionary) -> Dictionary:
	var full_grid = {}

	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var pos = Vector2i(x, y)

			if solution.has(pos):
				full_grid[pos] = solution[pos]
			else:
				full_grid[pos] = random_pipe()

	return full_grid

func generate_level():
	start_cell = Vector2i(0, 0)
	end_cell = Vector2i(grid_size.y - 1, grid_size.x - 1)

	var path = generate_path()
	var solution = path_to_pipes(path)
	var full_grid = fill_grid(solution)

	return {
		"grid": full_grid,
		"solution": solution,
		"start": start_cell,
		"end": end_cell
	}
