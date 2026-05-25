class_name Player
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

# Startwert für die Punkte.
var score = 0

# Speichert die Anzahl der ausgeführten Sprünge für den Doppelsprung.
var jumps_made = 0
const MAX_JUMPS = 2

@onready var anim_sprite = $AnimatedSprite2D

# Variablen für das Verlieren (Game Over).
var is_dead = false
@onready var game_over_screen = $CanvasLayer/GameOverScreen
@onready var score_bar = $CanvasLayer/ScoreBar

# Wird einmal am Anfang aufgerufen.
func _ready():
	_setup_wasd_inputs()
	game_over_screen.hide()
	_update_ui()

# Fügt WASD-Tasten zu den Standard-Aktionen hinzu (für einfaches Bewegen ohne Einstellungen).
func _setup_wasd_inputs():
	var key_a = InputEventKey.new()
	key_a.physical_keycode = KEY_A
	InputMap.action_add_event("ui_left", key_a)
	
	var key_d = InputEventKey.new()
	key_d.physical_keycode = KEY_D
	InputMap.action_add_event("ui_right", key_d)
	
	var key_w = InputEventKey.new()
	key_w.physical_keycode = KEY_W
	InputMap.action_add_event("ui_accept", key_w) # Leertaste / W für Springen
	InputMap.action_add_event("ui_up", key_w)

# Wird jeden Frame ausgeführt, zuständig für Physik und Bewegung.
func _physics_process(delta):
	# Wenn der Spieler tot ist, warte auf Neustart.
	if is_dead:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
		return

	# Schwerkraft anwenden, wenn der Spieler nicht auf dem Boden steht.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Setze die Sprünge zurück, wenn wir auf dem Boden sind.
	if is_on_floor():
		jumps_made = 0

	# Springen (inklusive Doppelsprung).
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and jumps_made < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jumps_made += 1

	# Bewegung nach links und rechts.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
		# Dreht das Bild um, wenn wir nach links laufen.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("idle")

	# Bewegt den Spieler und wendet Kollisionen an.
	move_and_slide()

	# Wenn der Spieler aus der Welt fällt, stirbt er sofort.
	if global_position.y > 1000:
		take_damage(999)

# Fügt dem Spieler Punkte hinzu.
func add_score(amount):
	score += amount
	_update_ui()

# Zieht dem Spieler Punkte ab.
func take_damage(amount):
	if is_dead: return
	score -= amount
	_update_ui()
	# Wenn die Punkte unter 0 fallen, hat man verloren.
	if score < 0:
		_die()

# Lässt den Spieler sterben und zeigt den Game Over Bildschirm.
func _die():
	is_dead = true
	game_over_screen.show()
	velocity = Vector2.ZERO

# Aktualisiert die Anzeige (Text und Balken) für die Punkte.
func _update_ui():
	$CanvasLayer/ScoreLabel.text = str(max(score, 0))
	score_bar.value = max(score, 0)

