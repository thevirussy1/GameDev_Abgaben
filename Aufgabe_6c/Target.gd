extends Area2D
# Ziel-Objekt (Komet) für den Gallery Shooter

signal time_added

var hovering: bool = false
var difficulty: int = 1

func _on_mouse_entered():
	hovering = true
	modulate = Color(1.2, 1.2, 1.2) # Aufhellen bei Hover

func _on_mouse_exited():
	hovering = false
	modulate = Color(1.0, 1.0, 1.0) # Zurücksetzen

func _unhandled_input(event):
	if event.is_action_pressed("mouse_left") and hovering:
		# Prüfe ob Munition vorhanden ist
		var zone = get_tree().current_scene
		if zone and zone.has_method("verbrauche_munition"):
			if not zone.verbrauche_munition():
				return # Keine Munition – kein Treffer
		time_added.emit(difficulty)
		_treffer_feedback()

func _treffer_feedback():
	# Bonus: Visueller Treffer-Effekt (Farbblitz + Partikel)
	hovering = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.visible = false
	if has_node("TrefferPartikel"):
		var partikel = $TrefferPartikel as CPUParticles2D
		partikel.emitting = true
		# Warte bis Partikel fertig sind, dann lösche
		await get_tree().create_timer(partikel.lifetime).timeout
	queue_free()

func _on_animation_player_animation_finished(_anim_name):
	# Ziel hat den Bildschirm verlassen – aufräumen
	get_parent().queue_free()
