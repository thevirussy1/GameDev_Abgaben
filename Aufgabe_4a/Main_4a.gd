extends Node2D

@onready var countdown_label = $UI/CountdownLabel
var spawners: Array = []
var current_spawner_idx = 0
var timer: Timer

func _ready():
	# Wir suchen alle Spawner in der Szene
	var all_spawners = get_tree().get_nodes_in_group("spawner")
	for s in all_spawners:
		spawners.append(s)
		
	# Ein zentraler Timer für alle Spawner
	timer = Timer.new()
	timer.wait_time = 10.0
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout():
	if spawners.size() > 0:
		# Den aktuellen Spawner auslösen
		spawners[current_spawner_idx].spawn_enemy()
		# Zum nächsten Spawner wechseln
		current_spawner_idx = (current_spawner_idx + 1) % spawners.size()

func _process(_delta):
	if timer:
		countdown_label.text = "Nächster Gegner in: " + str(snapped(timer.time_left, 0.1)) + "s"


