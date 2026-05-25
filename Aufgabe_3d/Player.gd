extends CharacterBody3D

# Signale für Treffer und Sounds
signal hit
signal jumped
signal squashed_enemy

# Variablen für die Bewegung (Werte aus dem Tutorial)
@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO
var can_double_jump = false

func _physics_process(delta):
	var direction = Vector3.ZERO

	# Eingaben abfragen (8 Richtungen)
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	# Normalisierung verhindert zu schnelles diagonales Laufen
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
		# Animation wird beim Laufen 4x schneller
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1

	# Geschwindigkeit auf dem Boden
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertikale Geschwindigkeit (Schwerkraft)
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	else:
		# Double Jump wird am Boden aufgeladen
		can_double_jump = true

	# Sprung-Logik (inklusive Bonus: Double Jump)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			target_velocity.y = jump_impulse
			jumped.emit()
		elif can_double_jump:
			target_velocity.y = jump_impulse
			can_double_jump = false
			jumped.emit()

	# Kollisionen prüfen (Gegner stampfen)
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue

		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# Prüfen, ob wir von oben kommen (Punktprodukt)
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				squashed_enemy.emit()
				break

	# Bewegung ausführen
	velocity = target_velocity
	move_and_slide()
	
	# Begrenzung, damit der Ball im Fenster bleibt
	position.x = clamp(position.x, -6.0, 6.0)
	position.z = clamp(position.z, -9.0, 9.0)
	
	# Leichte Neigung des Modells beim Springen
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

# Funktion für das Sterben
func die():
	hit.emit()
	queue_free()

# Signal von der MobDetector-Area
func _on_mob_detector_body_entered(_body):
	die()
