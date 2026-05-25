extends Area2D

# Wie viele Punkte man verliert, wenn man die Stacheln berührt.
@export var damage: int = 1

# Abklingzeit, damit der Spieler nicht jeden Frame Schaden bekommt.
var cooldown: float = 0.0
const COOLDOWN_TIME: float = 1.0

# Wird am Anfang aufgerufen.
func _ready():
	# Verknüpft die Kollision mit unserer Methode unten.
	body_entered.connect(_on_body_entered)

# Wird durchgehend ausgeführt. Reduziert die Wartezeit.
func _process(delta):
	if cooldown > 0:
		cooldown -= delta

# Wird aufgerufen, wenn jemand die Stacheln berührt.
func _on_body_entered(body):
	# Wenn es der Spieler ist und die Abklingzeit vorbei ist:
	if body is Player and cooldown <= 0:
		body.take_damage(damage)
		# Setze die Wartezeit auf 1 Sekunde zurück, bevor es wieder wehtut.
		cooldown = COOLDOWN_TIME
