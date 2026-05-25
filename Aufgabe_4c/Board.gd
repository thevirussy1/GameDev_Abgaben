class_name Board
extends RefCounted

var width: int = 10
var height: int = 20
var grid: Array = []

func _init():
	# ein leeres 2D-Array für das Raster (10 Spalten, 20 Reihen).
	for x in range(width):
		var col = []
		col.resize(height)
		col.fill(null)
		grid.append(col)

# Prüft, ob sich eine Position innerhalb des 10x20 Rasters befindet.
func is_inside(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height

# Prüft, ob eine Position innerhalb des Rasters und noch frei ist (null).
func is_cell_free(pos: Vector2i) -> bool:
	return is_inside(pos) and grid[pos.x][pos.y] == null

# Prüft, ob alle Zellen einer Form an eine gültige Position gesetzt werden können.
func is_valid_position(cells: Array) -> bool:
	for c in cells:
		if not is_cell_free(c):
			return false
	return true

# Verankert die Form fest im Raster.
func place_tetromino(cells: Array, color: Color):
	for c in cells:
		grid[c.x][c.y] = color

# Sucht nach vollen Linien, löscht sie und rückt alles von oben nach unten.
func clear_lines() -> int:
	var lines_cleared = 0
	# Fange unten an (Reihe 19) und arbeite dich nach oben (Reihe 0).
	var y = height - 1
	while y >= 0:
		if is_line_full(y):
			clear_line(y)
			shift_down(y)
			lines_cleared += 1
			# Wir bleiben auf derselben y-Höhe, da eine neue Linie von oben heruntergerutscht ist
		else:
			y -= 1
	return lines_cleared

# Prüft, ob eine komplette horizontale Linie (Reihe y) gefüllt ist.
func is_line_full(y: int) -> bool:
	for x in range(width):
		if grid[x][y] == null:
			return false
	return true

# Löscht alle Blöcke in Reihe y.
func clear_line(y: int):
	for x in range(width):
		grid[x][y] = null

# Lässt alle Blöcke, die sich über der gelöschten Reihe (from_y) befinden, um 1 nach unten fallen.
func shift_down(from_y: int):
	# Gehe von der gelöschten Zeile nach oben
	for y in range(from_y - 1, -1, -1):
		for x in range(width):
			grid[x][y + 1] = grid[x][y]
			grid[x][y] = null
