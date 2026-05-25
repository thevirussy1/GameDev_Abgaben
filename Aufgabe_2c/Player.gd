extends Area2D

signal hit

@export var speed = 400 # Wie schnell sich der Spieler bewegen wird
var screen_size # Größe des Spielfensters.

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # Der Bewegungsvektor des Spielers
	if Input.is_action_pressed("move_right") or Input.is_physical_key_pressed(KEY_D):
		velocity.x += 1
	if Input.is_action_pressed("move_left") or Input.is_physical_key_pressed(KEY_A):
		velocity.x -= 1
	if Input.is_action_pressed("move_down") or Input.is_physical_key_pressed(KEY_S):
		velocity.y += 1
	if Input.is_action_pressed("move_up") or Input.is_physical_key_pressed(KEY_W):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(_body):
	hide() # Der Spieler verschwindet, nachdem er getroffen wurde
	hit.emit()
	# Muss verzögert werden, da wir keine Physik-Eigenschaften während eines Physik-Callbacks ändern können
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
