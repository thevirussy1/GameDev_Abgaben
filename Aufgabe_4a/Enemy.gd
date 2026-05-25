extends CharacterBody2D

# Zwei Bewegungsmodi (laut Aufgabe 02)
enum Mode { PATROL, CHASE }

@export var speed = 150.0
@export var chase_threshold = 200.0 # Kleinere Distanz zum Verfolgen
@export var patrol_points : Array[Vector2]

var current_mode = Mode.PATROL
var current_point_index = 0
var player = null

@onready var nav_agent = $NavigationAgent2D

func _ready():
	# Initialisierung laut Aufgabe
	player = get_tree().get_first_node_in_group("player")
	if patrol_points.size() > 0:
		nav_agent.target_position = patrol_points[current_point_index]

func _physics_process(_delta):
	if player == null:
		return

	# Distanz berechnen
	var distance = global_position.distance_to(player.global_position)
	
	# Logik aus Aufgabe 02: Umschalten bei Threshold
	if distance < chase_threshold:
		current_mode = Mode.CHASE
	else:
		current_mode = Mode.PATROL
	
	# Bewegungs-Modi ausführen
	if current_mode == Mode.CHASE:
		# Direkt zum Spieler (Bonus: über NavigationAgent2D für Hindernisse)
		nav_agent.target_position = player.global_position
	else:
		# Patrouille zwischen Punkten
		if patrol_points.size() > 0:
			if nav_agent.is_navigation_finished():
				current_point_index = (current_point_index + 1) % patrol_points.size()
				nav_agent.target_position = patrol_points[current_point_index]
	
	# Bewegung ausführen (move_and_slide laut Aufgabe 01)
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	velocity = direction * speed
	move_and_slide()

	# Reaktion bei Kontakt (laut Aufgabe 03)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

