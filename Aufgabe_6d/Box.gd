extends Node2D

const SIZE = Vector2(40, 40)
@onready var sprite = $Sprite2D

var velocity: Vector2 = Vector2(100, 100) # Bewegt sich diagonal
var bounds: Rect2 = Rect2(0, 0, 480, 720)

func _ready() -> void:
	sprite.modulate = Color(1.0, 0.4, 0.2)  # Orange Farbe

func _process(delta: float) -> void:
	var motion = velocity * delta
	
	var collided = false
	var final_position = position
	
	# X-Achse testen
	if motion.x != 0:
		var test_pos_x = final_position + Vector2(motion.x, 0)
		if not check_collision(test_pos_x):
			final_position.x = test_pos_x.x
		else:
			velocity.x = -velocity.x
			collided = true
			
	# Y-Achse testen
	if motion.y != 0:
		var test_pos_y = final_position + Vector2(0, motion.y)
		if not check_collision(test_pos_y):
			final_position.y = test_pos_y.y
		else:
			velocity.y = -velocity.y
			collided = true

	if collided:
		sprite.modulate = Color(1.0, 0.2, 0.2) # Bei Kollision rot färben
	else:
		sprite.modulate = Color(1.0, 0.4, 0.2) # Zurück zu Orange
		
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
