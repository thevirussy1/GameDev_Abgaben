extends CharacterBody2D

# Die zwei verschiedenen Zustände für die Gegner-Bewegung.
enum Mode { PATROL, CHASE }

# Wie schnell sich der Gegner bewegt.
@export var speed = 150.0

# Ab welcher Distanz zum Spieler der Gegner in den Verfolgungs-Modus wechselt.
@export var chase_threshold = 200.0

# Die Liste an Punkten, zwischen denen der Gegner hin- und herläuft.
@export var patrol_points : Array[Vector2]

# Der aktuelle Bewegungs-Modus (wir starten mit Patrouillieren).
var current_mode = Mode.PATROL

# Der Punkt in der Liste, auf den der Gegner gerade zuläuft.
var current_point_index = 0

# Referenz auf unseren Spieler.
var player = null

# Der Navigations-Agent für eine schlaue Wegfindung um Hindernisse herum.
@onready var nav_agent = $NavigationAgent2D

# Wird beim Spielstart aufgerufen.
func _ready():
	# Wir suchen den Spieler in der Szene über seine Gruppe.
	player = get_tree().get_first_node_in_group("player")
	# Wenn wir Patrouillen-Punkte haben, steuern wir direkt den ersten an.
	if patrol_points.size() > 0:
		nav_agent.target_position = patrol_points[current_point_index]

# Wird in jedem Physik-Frame ausgeführt.
func _physics_process(_delta):
	if player == null:
		return

	# Wir berechnen die Distanz zwischen dem Gegner und dem Spieler.
	var distance = global_position.distance_to(player.global_position)
	
	# Wenn der Spieler nahe genug ist, wird er verfolgt. Ansonsten patrouillieren wir.
	if distance < chase_threshold:
		current_mode = Mode.CHASE
	else:
		current_mode = Mode.PATROL
	
	# Führe die entsprechende Logik für den aktuellen Zustand aus.
	if current_mode == Mode.CHASE:
		# Zielposition auf die aktuelle Position des Spielers setzen.
		nav_agent.target_position = player.global_position
	else:
		# Wenn wir patrouillieren und den aktuellen Punkt erreicht haben, laufen wir zum nächsten.
		if patrol_points.size() > 0:
			if nav_agent.is_navigation_finished():
				current_point_index = (current_point_index + 1) % patrol_points.size()
				nav_agent.target_position = patrol_points[current_point_index]
	
	# Ermittle den nächsten Wegpunkt auf dem Navigations-Pfad.
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	
	# Berechne die Geschwindigkeit und führe die Bewegung aus.
	velocity = direction * speed
	move_and_slide()

	# Kollisionsprüfung: Wenn wir den Spieler berühren, fügen wir ihm Schaden zu.
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

