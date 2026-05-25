extends Node

# Die Mob-Szene muss im Inspektor zugewiesen werden
@export var mob_scene: PackedScene

func _ready():
	# Neustart-Overlay am Anfang verstecken
	$UserInterface/Retry.hide()

# Wird alle 0,5 Sekunden vom MobTimer aufgerufen
func _on_mob_timer_timeout():
	# Neue Instanz des Gegners erstellen
	var mob = mob_scene.instantiate()

	# Zufälligen Punkt auf dem SpawnPath wählen
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Gegner initialisieren und zum Spieler schicken
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Gegner zur Szene hinzufügen
	add_child(mob)
	
	# Signal verbinden, um den Score zu erhöhen
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed)

# Wenn der Spieler getroffen wird
func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()

# Eingaben für den Neustart prüfen
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# Lädt die aktuelle Szene neu (Restart)
		get_tree().reload_current_scene()

# Sound-Trigger für Aktionen
func _on_player_jumped():
	$JumpSound.play()

func _on_player_squashed_enemy():
	$StompSound.play()
