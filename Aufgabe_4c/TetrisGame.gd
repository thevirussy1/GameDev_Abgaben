extends Node2D

const CELL_SIZE = 32

var board: Board
var fall_time: float = 0.8
var soft_drop_multiplier: float = 5.0

# Bonus: Erhöhung der Geschwindigkeit
var minimum_fall_time: float = 0.1
var speed_increase_per_line: float = 0.02

var fall_timer: float = 0.0
var current_fall_interval: float = 0.8

var current_shape: Dictionary
var current_pos: Vector2i
var current_rotation: int = 0
var soft_dropping: bool = false
var is_game_over: bool = false
var score: int = 0

@onready var score_label = $CanvasLayer/ScoreLabel
@onready var game_over_label = $CanvasLayer/GameOverLabel

func _ready():
	board = Board.new()
	game_over_label.hide()
	score_label.text = "Score: 0"
	spawn_next()

# Wird jeden Frame aufgerufen
func _process(delta):
	if is_game_over:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
		return
		
	fall_timer += delta
	if fall_timer >= current_fall_interval:
		fall_timer = 0.0
		step_down()
		
	queue_redraw() # Zeichnet das Spielfeld jeden Frame neu

# Nimmt Tasten-Eingaben entgegen
func _input(event):
	if is_game_over: return
	
	if event.is_action_pressed("ui_left"):
		try_move(Vector2i.LEFT)
	elif event.is_action_pressed("ui_right"):
		try_move(Vector2i.RIGHT)
	elif event.is_action_pressed("ui_up"):
		try_rotate(1) # Rotieren im Uhrzeigersinn
	elif event.is_action_pressed("ui_down"):
		soft_dropping = true
		current_fall_interval = max(0.01, fall_time / soft_drop_multiplier)
	elif event.is_action_released("ui_down"):
		soft_dropping = false
		current_fall_interval = fall_time
	elif event.is_action_pressed("ui_accept"):
		# Hard Drop: Fällt so tief wie möglich
		while try_move(Vector2i.DOWN):
			pass
		lock_current()

# Fällt einen Schritt nach unten
func step_down():
	if not try_move(Vector2i.DOWN):
		lock_current()

# Versucht, den Block zu bewegen
func try_move(delta: Vector2i) -> bool:
	current_pos += delta
	if not board.is_valid_position(get_current_cells()):
		current_pos -= delta # Ungültig, rückgängig machen
		return false
	return true

# Versucht, den Block zu rotieren
func try_rotate(dir: int) -> bool:
	var old_rot = current_rotation
	current_rotation = (current_rotation + dir) % 4
	if current_rotation < 0:
		current_rotation += 4
		
	if not board.is_valid_position(get_current_cells()):
		current_rotation = old_rot # Ungültig, rückgängig machen
		return false
	return true

# Fixiert den fallenden Block auf dem Spielfeld und testet auf volle Reihen
func lock_current():
	board.place_tetromino(get_current_cells(), current_shape.color)
	var cleared = board.clear_lines()
	if cleared > 0:
		handle_lines_cleared(cleared)
	
	if not spawn_next():
		game_over()

# Spawnt einen neuen zufälligen Block oben in der Mitte
func spawn_next() -> bool:
	var shapes = TetrominoLibrary.SHAPES.values()
	current_shape = shapes[randi() % shapes.size()]
	current_pos = Vector2i(board.width / 2, 0)
	current_rotation = 0
	
	if not board.is_valid_position(get_current_cells()):
		return false # Game Over, Es ist kein Platz mehr
	return true

# Berechnet die Punkte, wenn Reihen gelöscht wurden (Bonus-Aufgabe)
func handle_lines_cleared(count: int):
	var points = 0
	match count:
		1: points = 100
		2: points = 300
		3: points = 500
		4: points = 800 # Tetris
	score += points
	score_label.text = "Score: " + str(score)
	
	# Schwierigkeit (Geschwindigkeit) erhöhen
	fall_time = max(minimum_fall_time, fall_time - (speed_increase_per_line * count))
	if not soft_dropping:
		current_fall_interval = fall_time

# Stoppt das Spiel
func game_over():
	is_game_over = true
	game_over_label.show()

# Berechnet die Positionen aller 4 Blöcke der aktuellen Form, inkl. Rotation
func get_current_cells() -> Array:
	var cells = []
	for cell in current_shape.cells:
		var x = cell.x
		var y = cell.y
		# Rotation im Uhrzeigersinn (90 Grad)
		for i in range(current_rotation):
			var temp = x
			x = -y
			y = temp
		cells.append(Vector2i(current_pos.x + x, current_pos.y + y))
	return cells

# Zeichnet das gesamte Tetris-Spielfeld in 2D
func _draw():
	# 1. Schwarzer Hintergrund
	draw_rect(Rect2(0, 0, board.width * CELL_SIZE, board.height * CELL_SIZE), Color(0.1, 0.1, 0.1))
	
	# 2. Raster-Linien (Gitter)
	var line_color = Color(1, 1, 1, 0.1)
	for x in range(board.width + 1):
		draw_line(Vector2(x * CELL_SIZE, 0), Vector2(x * CELL_SIZE, board.height * CELL_SIZE), line_color)
	for y in range(board.height + 1):
		draw_line(Vector2(0, y * CELL_SIZE), Vector2(board.width * CELL_SIZE, y * CELL_SIZE), line_color)
		
	# 3. Festgesetzte (tote) Blöcke
	for x in range(board.width):
		for y in range(board.height):
			if board.grid[x][y] != null:
				draw_block(x, y, board.grid[x][y])
				
	# 4. Der aktive (fallende) Block
	for c in get_current_cells():
		draw_block(c.x, c.y, current_shape.color)

# Hilfsfunktion zum Zeichnen eines einzelnen Quadrats
func draw_block(x: int, y: int, color: Color):
	var rect = Rect2(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
	# Verkleinere das Rechteck um 1 Pixel für den Raster-Effekt!
	rect = rect.grow(-1)
	draw_rect(rect, color)
