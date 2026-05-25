extends Node2D

# Vom Spieler gesteuertes Rechteck
# Größe des Rechtecks (wird für AABB verwendet)
const SIZE = Vector2(40, 40)

@onready var sprite = $Sprite2D

func _ready() -> void:
	# Anfängliche Farbe (keine Kollision)
	sprite.modulate = Color(0.2, 0.4, 1.0)  # Blau

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_D) or Input.is_action_pressed("ui_right"):
		velocity.x += 200
	if Input.is_physical_key_pressed(KEY_A) or Input.is_action_pressed("ui_left"):
		velocity.x -= 200
	if Input.is_physical_key_pressed(KEY_S) or Input.is_action_pressed("ui_down"):
		velocity.y += 200
	if Input.is_physical_key_pressed(KEY_W) or Input.is_action_pressed("ui_up"):
		velocity.y -= 200
	
	var motion = velocity * delta
	
	var collided = false
	var final_position = position
	
	# X-Achse testen
	if motion.x != 0:
		var test_pos_x = final_position + Vector2(motion.x, 0)
		if not check_collision(test_pos_x):
			final_position.x = test_pos_x.x
		else:
			collided = true
			
	# Y-Achse testen
	if motion.y != 0:
		var test_pos_y = final_position + Vector2(0, motion.y)
		if not check_collision(test_pos_y):
			final_position.y = test_pos_y.y
		else:
			collided = true

	if collided:
		# Bei Kollision die Farbe auf Grün ändern
		sprite.modulate = Color(0.2, 1.0, 0.2)  # Grün
	else:
		# Keine Kollision – normale Farbe beibehalten
		sprite.modulate = Color(0.2, 0.4, 1.0)  # Blau
		
	position = final_position

func check_collision(test_position: Vector2) -> bool:
	var my_pos = test_position - SIZE / 2
	for body in get_tree().get_nodes_in_group("collidable"):
		if body == self:
			continue
			
		var other_sprite = body.get_node_or_null("Sprite2D")
		if other_sprite and other_sprite.texture:
			var other_size = other_sprite.texture.get_size()
			var other_pos = body.position - other_size / 2
			
			if AABBCollision.intersect(my_pos, SIZE, other_pos, other_size):
				return true
	return false
