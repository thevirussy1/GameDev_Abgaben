extends Node2D

# Referenz auf die Anzeige des Timers in der Benutzeroberfläche.
@onready var countdown_label = $UI/CountdownLabel

# Liste aller Spawner, die wir in der Szene finden.
var spawners: Array = []

# Welcher Spawner als nächstes an der Reihe ist, einen Gegner zu erzeugen.
var current_spawner_idx = 0

# Der Timer, der das periodische Spawnen der Gegner regelt.
var timer: Timer

# Wird aufgerufen, wenn die Szene fertig geladen ist.
func _ready():
	# Alle Spawner in der Szene über ihre Gruppe ausfindig machen.
	var all_spawners = get_tree().get_nodes_in_group("spawner")
	for s in all_spawners:
		spawners.append(s)
		
	# Wir erstellen einen neuen Timer direkt aus dem Code heraus.
	timer = Timer.new()
	timer.wait_time = 10.0
	timer.autostart = true
	# Wir verbinden das Timeout-Signal mit unserer eigenen Funktion.
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

# Wird aufgerufen, sobald der 10-Sekunden-Timer abgelaufen ist.
func _on_timer_timeout():
	if spawners.size() > 0:
		# Den aktuellen Spawner anweisen, einen Gegner zu erschaffen.
		spawners[current_spawner_idx].spawn_enemy()
		# Zum nächsten Spawner in der Liste wechseln (mit Umbruch am Ende der Liste).
		current_spawner_idx = (current_spawner_idx + 1) % spawners.size()

# Wird jeden Frame ausgeführt, um die UI-Anzeige zu aktualisieren.
func _process(_delta):
	if timer:
		# Zeigt die verbleibende Zeit auf eine Dezimalstelle gerundet an.
		countdown_label.text = "Nächster Gegner in: " + str(snapped(timer.time_left, 0.1)) + "s"
