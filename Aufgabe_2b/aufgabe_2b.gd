extends Node2D

# Wir benutzen ein Enum für die verschiedenen Zustände
enum Weather { SUNNY, RAINY, STORMY }

# Zustand am Anfang
var current_state = Weather.SUNNY

# Von 3 Sekunden runterzählen
var timer = 3.0

func _process(delta):
	# Den Timer runterzählen
	timer = timer - delta
	
	# Das Label zeigt jetzt dynamisch den Status und die Zeit an
	var status_name = ""
	
	# Je nach Zustand machen wir etwas anderes (Visualisierung)
	if current_state == Weather.SUNNY:
		status_name = "SONNIG"
		$Sprite2D.modulate = Color.YELLOW
		$Sprite2D.rotation += delta # Es dreht sich langsam
	
	elif current_state == Weather.RAINY:
		status_name = "REGEN"
		$Sprite2D.modulate = Color.BLUE
		$Sprite2D.position.y += 100 * delta # Fällt wie Regen
		if $Sprite2D.position.y > 450:
			$Sprite2D.position.y = 250
			
	elif current_state == Weather.STORMY:
		status_name = "STURM"
		$Sprite2D.modulate = Color.DARK_SLATE_GRAY
		# Schnelles Wackeln
		$Sprite2D.position.x = 240 + randf_range(-10, 10)

	# Hier wird das Label jetzt benutzt mit Countdown
	$Label.text = "Wetter: " + status_name + "\nNächster Wechsel in: " + str(snapped(timer, 0.1)) + "s"

	# Wenn der Timer bei 0 ist, wechseln wir das Wetter
	if timer <= 0:
		timer = 3.0
		_change_weather()

func _change_weather():
	# Position zurücksetzen für den nächsten Zustand
	$Sprite2D.position = Vector2(240, 300)
	$Sprite2D.rotation = 0
	
	if current_state == Weather.SUNNY:
		current_state = Weather.RAINY
	elif current_state == Weather.RAINY:
		current_state = Weather.STORMY
	else:
		current_state = Weather.SUNNY
