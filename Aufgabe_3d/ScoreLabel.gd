extends Label

# Aktueller Punktestand
var score = 0

# Wird aufgerufen, wenn ein Gegner besiegt wird
func _on_mob_squashed():
	score += 1
	# Text aktualisieren (Score-Anzeige)
	text = "Score: %s" % score
