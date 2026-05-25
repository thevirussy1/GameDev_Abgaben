extends Node3D

const BALL_SCENE = preload("res://Abgaben/Aufgabe_6b/PhysicsBall.tscn")

@onready var camera = $Camera3D

# Cooldown fuer die F-Taste: max. 2x pro 30 Sekunden
var anstupser_zaehler: int = 0
const ANSTUPSER_MAX: int = 2
const ANSTUPSER_COOLDOWN: float = 30.0
var cooldown_timer: float = 0.0

# Begrenzung: max. 3 Kanonenkugeln gleichzeitig in der Szene
var kanonen_zaehler: int = 0
const KANONEN_MAX: int = 3

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Gummiball -> leuchtendes Pink
	var bounce_mat = StandardMaterial3D.new()
	bounce_mat.albedo_color = Color(1.0, 0.08, 0.58)
	bounce_mat.roughness = 0.15
	bounce_mat.metallic = 0.1
	if has_node("BounceBall/MeshInstance3D"):
		$BounceBall/MeshInstance3D.material_override = bounce_mat
	
	# Steinball -> mattes Schiefergrau
	var stone_mat = StandardMaterial3D.new()
	stone_mat.albedo_color = Color(0.4, 0.45, 0.48)
	stone_mat.roughness = 0.95
	stone_mat.metallic = 0.05
	if has_node("StoneBall/MeshInstance3D"):
		$StoneBall/MeshInstance3D.material_override = stone_mat

func _process(delta: float) -> void:
	# Cooldown-Timer fuer die F-Taste
	if anstupser_zaehler >= ANSTUPSER_MAX:
		cooldown_timer += delta
		if cooldown_timer >= ANSTUPSER_COOLDOWN:
			anstupser_zaehler = 0
			cooldown_timer = 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()
		
		if event.keycode == KEY_F:
			if anstupser_zaehler < ANSTUPSER_MAX:
				anstupsen_vergleichs_baelle()
				anstupser_zaehler += 1
				cooldown_timer = 0.0
				print("Anstupser: %d/%d" % [anstupser_zaehler, ANSTUPSER_MAX])
			else:
				print("Cooldown! Noch %.0f Sek. warten." % (ANSTUPSER_COOLDOWN - cooldown_timer))
	
	if event.is_action_pressed("ui_accept"):
		feuere_kanone_ab()

func anstupsen_vergleichs_baelle() -> void:
	var stups = Vector3(0, 7.0, 0)
	if has_node("BounceBall"):
		($BounceBall as RigidBody3D).apply_impulse(stups)
	if has_node("StoneBall"):
		($StoneBall as RigidBody3D).apply_impulse(stups)

func feuere_kanone_ab() -> void:
	# Maximal 3 Kugeln gleichzeitig erlaubt, um Chaos zu vermeiden
	if kanonen_zaehler >= KANONEN_MAX:
		print("Maximal %d Kanonenkugeln gleichzeitig!" % KANONEN_MAX)
		return
	
	var ball = BALL_SCENE.instantiate()
	add_child(ball)
	kanonen_zaehler += 1
	
	# Spawn direkt vor der Kamera (zwischen Kamera und Turm),
	# sodass es aussieht als wuerde man aus Kameraperspektive schiessen.
	ball.global_position = Vector3(0.0, 6.0, 12.0)
	
	# Eisen-Grau fuer die Kanonenkugel
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.12, 0.15, 0.18) 
	mat.metallic = 0.85
	mat.roughness = 0.25
	var mesh_inst = ball.get_node("MeshInstance3D") as MeshInstance3D
	if mesh_inst:
		mesh_inst.material_override = mat
	
	# Schwere Kanonenkugel fuer mehr Wumms
	ball.mass = 15.0
	
	# Ziel: Mitte des Kistenturms — direkt auf die Kisten zielen
	var ziel = Vector3(0.0, 3.0, 0.0)
	var richtung = (ziel - ball.global_position).normalized()
	
	# Starker Impuls: apply_impulse() feuert die Kugel kraftvoll ab
	ball.apply_impulse(richtung * 100.0)
	
	# Zaehler nach 6 Sekunden wieder freigeben
	await get_tree().create_timer(6.0).timeout
	kanonen_zaehler = max(0, kanonen_zaehler - 1)
