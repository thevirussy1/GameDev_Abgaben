extends Area2D

# Dieses Signal wird gesendet, wenn die Münze eingesammelt wird.
signal collected

# Wie viele Punkte die Münze wert ist.
@export var score: int = 1

# Wird am Start aufgerufen, um alles zu verknüpfen.
func _ready():
	# Wenn etwas diesen Bereich betritt, rufe die Funktion auf.
	var player_node = get_tree().get_first_node_in_group("Player")
	body_entered.connect(_on_body_entered)
	# Verbinde das Signal mit der Punkte-Funktion vom Spieler.
	if player_node:
		collected.connect(player_node.add_score)

# Wird ausgeführt, wenn ein Körper die Münze berührt.
func _on_body_entered(body):
	# Überprüfe, ob es sich wirklich um den Spieler handelt.
	if body is Player:
		emit_signal("collected", score)
		# Lösche die Münze aus dem Spiel.
		queue_free()

