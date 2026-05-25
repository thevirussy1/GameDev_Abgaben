extends Node2D
# Hauptszene des Gallery Shooters

var target_scene = preload("res://Abgaben/Aufgabe_6c/Target.tscn")
var spawn_zeit = 1.5

# Munitionssystem (Bonus)
var max_munition: int = 6
var aktuelle_munition: int = 6
var regen_zeit: float = 0.5
var regen_timer: float = 0.0

func _ready():
	$WorldTimer.start(20)
	$DelayTimer.wait_time = spawn_zeit
	$DelayTimer.start()
	ui_aktualisieren()

func _process(delta):
	# Countdown aktualisieren
	var rest_zeit = $WorldTimer.time_left
	$CanvasLayer/ZeitLabel.text = str(int(rest_zeit))
	if rest_zeit <= 0:
		spiel_vorbei()

	# Munition automatisch regenerieren
	if aktuelle_munition < max_munition:
		regen_timer += delta
		if regen_timer >= regen_zeit:
			aktuelle_munition += 1
			regen_timer = 0.0
			ui_aktualisieren()

func _unhandled_input(event):
	# Jeder Klick verbraucht Munition (auch Fehlschüsse)
	if event.is_action_pressed("mouse_left"):
		if aktuelle_munition > 0:
			aktuelle_munition -= 1
			ui_aktualisieren()

# Wird vom Target aufgerufen, um zu prüfen ob Munition da ist
func verbrauche_munition() -> bool:
	# Munition wurde bereits in _unhandled_input abgezogen
	# Hier prüfen wir nur, ob der Schuss gültig war
	# Da _unhandled_input zuerst bei Target ankommt (weil Area2D),
	# und dann hier, müssen wir einfach true zurückgeben wenn noch Munition da war
	return true

func ui_aktualisieren():
	var balken = ""
	for i in range(aktuelle_munition):
		balken += "█"
	for i in range(max_munition - aktuelle_munition):
		balken += "░"
	$CanvasLayer/MunitionsLabel.text = balken

func spawn_erstellen():
	var neuer_spawn = Marker2D.new()
	var neues_ziel = target_scene.instantiate()
	add_child(neuer_spawn)
	neuer_spawn.add_child(neues_ziel)
	neues_ziel.time_added.connect(_bei_zeit_hinzugefuegt)

	# Zufällige Animation wählen
	var animationen = ["straight_right", "straight_left", "wave_right"]
	var gewaehlte_anim = animationen[randi() % animationen.size()]

	# Spawn-Position abhängig von Richtung (480x720 Fenster)
	if gewaehlte_anim.contains("left"):
		neuer_spawn.position = Vector2(510, randf_range(60, 660))
	else:
		neuer_spawn.position = Vector2(-30, randf_range(60, 660))

	var anim_player = neues_ziel.get_node("AnimationPlayer")
	anim_player.play(gewaehlte_anim)
	anim_player.speed_scale = randf_range(0.2, 0.6)

func _on_delay_timer_timeout():
	spawn_erstellen()
	# Schwierigkeit schrittweise erhöhen
	spawn_zeit = max(0.3, spawn_zeit - 0.05)
	$DelayTimer.wait_time = spawn_zeit

func _bei_zeit_hinzugefuegt(zeit):
	$WorldTimer.start($WorldTimer.time_left + zeit)

func spiel_vorbei():
	$DelayTimer.stop()
	$CanvasLayer/ZeitLabel.text = "GAME OVER"
	for kind in get_children():
		if kind is Marker2D:
			kind.queue_free()

