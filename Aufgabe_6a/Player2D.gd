extends CharacterBody2D

# Maximale Geschwindigkeit des Spielers.
@export var max_speed = 400.0

# Wie schnell der Spieler an Fahrt gewinnt.
@export var acceleration = 2000.0

# Wie schnell der Spieler abbremst, wenn man keine Taste mehr drückt.
@export var friction = 1500.0

# Die Stärke des plötzlichen Ausweichschritts (Dash).
@export var dash_impulse = 1500.0

# Die Kraft, mit der wir physikalische Kisten wegschieben können.
@export var push_force = 2000.0

# Wird jeden Physik-Frame aufgerufen, regelt die Bewegung und Kollisionen.
func _physics_process(delta):
	var direction = Vector2.ZERO
	
	# Auslesen der Richtungstasten für die Bewegung.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"): # Runter laufen
		direction.y += 1
	if Input.is_action_pressed("move_forward"): # Hoch laufen
		direction.y -= 1

	# Wenn eine Richtungstaste gedrückt wird, beschleunigen wir den Spieler.
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		# Errechnet die neue Geschwindigkeit sanft in Richtung Zielgeschwindigkeit.
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	else:
		# Wenn nichts gedrückt wird, bremst die Reibung den Spieler sanft ab.
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	# Bonus-Mechanik: Ein kräftiger Dash (Sprint-Impuls) auf Knopfdruck.
	if Input.is_action_just_pressed("ui_accept"):
		# Wir dashen in die aktuelle Laufrichtung, standardmäßig nach rechts.
		var dash_dir = direction if direction != Vector2.ZERO else Vector2.RIGHT
		# Wir addieren den Impuls direkt auf unsere aktuelle Geschwindigkeit.
		velocity += dash_dir * dash_impulse

	# Führt die tatsächliche Bewegung aus und berechnet Kollisionen mit Wänden.
	move_and_slide()

	# Geht alle aktiven Kollisionen durch, um Kisten (RigidBody2D) zu verschieben.
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# Wenn wir gegen eine physikalische Kiste laufen.
		if collider is RigidBody2D:
			# Wir berechnen die Schieberichtung aus der Kollisionsnormale.
			var push_dir = -collision.get_normal()
			# Wende einen passenden physikalischen Impuls auf die Kiste an.
			collider.apply_central_impulse(push_dir * push_force * delta)

# Wird aufgerufen, wenn uns ein Gegner erwischt (lässt den Spieler rot aufblinken).
func hit():
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE

