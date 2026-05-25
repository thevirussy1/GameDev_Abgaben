class_name TetrominoLibrary
extends RefCounted

# Alle 7 Tetris-Formen mit ihren Farben und Koordinaten.
const SHAPES = {
	"I": {
		"color": Color(0, 1, 1), # Cyan
		"cells": [Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0)]
	},
	"O": {
		"color": Color(1, 1, 0), # Gelb
		"cells": [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
	},
	"T": {
		"color": Color(0.5, 0, 0.5), # Lila
		"cells": [Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1)]
	},
	"J": {
		"color": Color(0, 0, 1), # Blau
		"cells": [Vector2i(-1, 1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)]
	},
	"L": {
		"color": Color(1, 0.5, 0), # Orange
		"cells": [Vector2i(1, 1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)]
	},
	"S": {
		"color": Color(0, 1, 0), # Grün
		"cells": [Vector2i(-1, 0), Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1)]
	},
	"Z": {
		"color": Color(1, 0, 0), # Rot
		"cells": [Vector2i(-1, 1), Vector2i(0, 1), Vector2i(0, 0), Vector2i(1, 0)]
	}
}
