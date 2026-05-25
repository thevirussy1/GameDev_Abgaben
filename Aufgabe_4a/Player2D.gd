extends CharacterBody2D

# Geschwindigkeit in Pixeln pro Sekunde
@export var speed = 400.0

func _physics_process(delta):
	# Richtung aus der Input Map holen (4 Richtungen)

	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"): # Runter
		direction.y += 1
	if Input.is_action_pressed("move_forward"): # Hoch
		direction.y -= 1

	# Normalisieren verhindert, dass man diagonal schneller ist
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	# Geschwindigkeit berechnen 
	velocity = direction * speed

	# Bewegung ausführen und Kollisionen berechnen
	move_and_slide()

# Funktion für die Reaktion auf Kontakt (wird vom Gegner aufgerufen)
func hit():
	#Kurz rot blinken
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE

