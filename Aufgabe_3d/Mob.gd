extends CharacterBody3D

# Signal, wenn der Gegner zertrampelt wurde
signal squashed

@export var min_speed = 10
@export var max_speed = 18

func _physics_process(_delta):
	# Konstante Bewegung in die Blickrichtung
	move_and_slide()

# Wird von der Main-Szene aufgerufen beim Erzeugen
func initialize(start_position, player_position):
	# Gegner auf den Spieler ausrichten
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Zufällige Drehung um bis zu 45 Grad, damit sie nicht exakt stur geradeaus laufen
	rotate_y(randf_range(-PI / 4, PI / 4))

	# Zufällige Geschwindigkeit wählen
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	# Animation an die Geschwindigkeit anpassen
	$AnimationPlayer.speed_scale = float(random_speed) / min_speed

# Funktion zum Besiegen
func squash():
	squashed.emit()
	queue_free()

# Löschen, wenn der Gegner den Bildschirm verlässt
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
