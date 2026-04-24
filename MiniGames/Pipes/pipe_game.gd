extends Node2D

signal pipes_connected

const PIPE = preload("uid://bwj5jx5v4ljiw")
var cell_size : int = 64
var finished = false
@export var grid_size : Vector2i = Vector2i(5, 5)

@onready var canvas: Node2D = %Canvas

var grid = []
var start_cell = Vector2i(0,0)
var end_cell = Vector2i(grid_size.y - 1, grid_size.x - 1)
var start_input =  dir_to_index(Vector2i.LEFT)
var end_output = dir_to_index(Vector2i.DOWN)
var level = {}
var start_position = Vector2i(0,42)
var end_position = Vector2i(cell_size * (grid_size.x) - 21,cell_size * (grid_size.y ) + 42 - 10) 

func _ready():
	level = generate_level()
	generate_grid()

func generate_grid():
	reset_grid()
	var _grid = level["grid"]
	
	for y in range(grid_size.y):
		grid.append([])
		for x in range(grid_size.x):
			var pos = Vector2i(x, y)
			
			var pipe = PIPE.instantiate()
			pipe.position = Vector2(x, y) * cell_size
			canvas.add_child(pipe)
			pipe.set_connections(_grid[pos])
			pipe.pipe_rotated.connect(check_win_condition)
			grid[y].append(pipe)



func generate_level():
	var path = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0), Vector2i(4, 1), Vector2i(4, 2), Vector2i(3, 2), Vector2i(3, 1), Vector2i(2, 1), Vector2i(2, 2), Vector2i(1, 2), Vector2i(1, 1), Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 3), Vector2i(0, 4), Vector2i(1, 4), Vector2i(2, 4), Vector2i(2, 3), Vector2i(3, 3), Vector2i(4, 3), Vector2i(4, 4)]
	var solution = { Vector2i(0, 0): [1, 3], Vector2i(1, 0): [2, 4], Vector2i(2, 0): [2, 4], Vector2i(3, 0): [1, 3], Vector2i(4, 0): [1, 2], Vector2i(4, 1): [0, 2], Vector2i(4, 2): [2, 3], Vector2i(3, 2): [0, 3], Vector2i(3, 1): [0, 3], Vector2i(2, 1): [2, 3], Vector2i(2, 2): [2, 3], Vector2i(1, 2): [0, 3], Vector2i(1, 1): [0, 3], Vector2i(0, 1): [2, 3], Vector2i(0, 2): [0, 2], Vector2i(0, 3): [0, 2], Vector2i(0, 4): [1, 2], Vector2i(1, 4): [1, 3], Vector2i(2, 4): [0, 1], Vector2i(2, 3): [0, 1], Vector2i(3, 3): [1, 3], Vector2i(4, 3): [1, 2], Vector2i(4, 4): [0, 2] }

	var full_grid = fill_grid(solution)
	
	return {
		"grid": full_grid,
		"solution": solution,
		"path": path,
		"start": start_cell,
		"end": end_cell
	}

func generate_path() -> Array:
	var path = [start_cell]
	var current = start_cell
	var visited = {}
	visited[start_cell] = true
	
	while current != end_cell:
		var neighbors = []
		
		for dir in range(4):
			var next = current + dir_to_vector(dir)
			if not is_inside_grid(next) || visited.has(next):
				continue
			neighbors.append(next)
		
		if neighbors.is_empty():
			return generate_path()
		
		current = neighbors.pick_random()
		path.append(current)
		visited[current] = true
	if path.size() < 22 : return generate_path()
	return path

func path_to_pipes(path: Array) -> Dictionary:
	var pipes = {}
	
	for i in range(path.size()):
		var pos = path[i]
		if !pipes.has(pos):
			pipes[pos] = []
		
		var from = path[i - 1]
		var direction = dir_to_index(path[i] - from)
		# incoming connection
		if i > 0:
			pipes[pos].append(direction)
			
		
		# outgoing connection
		if i < path.size() - 1:
			var dir2 = dir_to_index(path[i + 1] - path[i])
			pipes[pos].append(dir2)
		
	
	# cleanup duplicates
	for p in pipes.keys():
		var cleaned = []
		for v in pipes[p]:
			if v not in cleaned:
				cleaned.append(v)
		pipes[p] = cleaned
		if pipes[p] == [1] or pipes[p] == [3]:
			pipes[p] = [1,3]
		if pipes[p] == [0] or pipes[p] == [2]:
			pipes[p] = [0,2]
		pipes[p].sort()
	
	return pipes

func random_pipe():
	var roll = randi() % 70
	var options = []
	
	# straight (common)
	if roll < 40:
		options = [[0,2], [1,3]] 
	# corners
	elif roll < 70:
		options = [[0,1],[1,2],[2,3],[3,0]] 
	# T pipes
	elif roll < 90:
		options = [[0,1,2],[1,2,3],[2,3,0],[3,0,1]]
	# cross (rare)
	else:
		options = [[0,1,2,3]]
	
	return options.pick_random()

func is_inside_grid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.y >= 0 \
		and pos.x < grid_size.x \
		and pos.y < grid_size.y

func dir_to_vector(dir: int):
	match dir:
		0: return Vector2i.UP
		1: return Vector2i.RIGHT
		2: return Vector2i.DOWN
		3: return Vector2i.LEFT
	return Vector2i.ZERO

func dir_to_index(diff: Vector2i) -> int:
	match(diff):
		Vector2i.UP: return 0
		Vector2i.RIGHT: return 1
		Vector2i.DOWN: return 2
		Vector2i.LEFT: return 3
	return -1

func opposite(dir: int) -> int:
	match dir:
		0: return 2
		1: return 3
		2: return 0
		3: return 1
	return -1

func fill_grid(solution: Dictionary) -> Dictionary:
	var full_grid = {}
	
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var pos = Vector2i(x, y)
			if solution.has(pos):
				full_grid[pos] = solution[pos]
			else:
				full_grid[pos] = []
	
	return full_grid

func reset_grid():
	for y in range(grid.size()):
		for x in range(grid[y].size()):
			if grid[y][x] != null:
				grid[y][x].queue_free()
	grid.clear()

func check_win_condition():
	var visited = {}
	var stack = [start_cell]
	
	
	var start_connections = grid[0][0].connections
	var end_connections = grid[grid_size.y - 1][grid_size.x - 1].connections
	if start_input not in start_connections || end_output not in end_connections:
		return
	
	while stack.size() > 0:
		var current_pos = stack.pop_back()
		
		if visited.has(current_pos):
			continue
		visited[current_pos] = true
		
		var current_pipe = grid[current_pos.y][current_pos.x]
		for dir in current_pipe.connections:
			var neighbor_pos = current_pos + dir_to_vector(dir)
			
			if not is_inside_grid(neighbor_pos) || visited.has(neighbor_pos):
				continue
			
			var neighbor_pipe = grid[neighbor_pos.y][neighbor_pos.x]
			if neighbor_pipe == null:
				continue
			
			if opposite(dir) in neighbor_pipe.connections:
				stack.append(neighbor_pos)

	if visited.has(end_cell):
		for y in range(grid_size.y):
			for x in range(grid_size.x):
				grid[x][y].enabled = false
		animate_water_flow(visited)

func animate_water_flow(visited):
	for pos in visited:
		var pipe = grid[pos.y][pos.x]
		await pipe.shake()
		await get_tree().create_timer(0.08).timeout
	
	pipes_connected.emit()
