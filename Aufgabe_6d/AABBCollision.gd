extends Node
class_name AABBCollision

static func intersect(a_pos: Vector2, a_size: Vector2, b_pos: Vector2, b_size: Vector2) -> bool:
	return (
		a_pos.x < b_pos.x + b_size.x and
		a_pos.x + a_size.x > b_pos.x and
		a_pos.y < b_pos.y + b_size.y and
		a_pos.y + a_size.y > b_pos.y
	)

# Löst die Kollision auf, indem die Bewegung auf der Aufprallachse gestoppt wird.
static func resolve_stop(velocity: Vector2, a_pos: Vector2, a_size: Vector2, b_pos: Vector2, b_size: Vector2) -> Vector2:
	var new_vel = velocity
	if intersect(a_pos, a_size, b_pos, b_size):
		# Einfacher Stopp: Setze die Geschwindigkeit auf beiden Achsen auf Null.
		new_vel = Vector2.ZERO
	return new_vel
