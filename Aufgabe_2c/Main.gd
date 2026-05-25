extends Node

@export var mob_scene: PackedScene
var score
var high_score = 0

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
	if score > high_score:
		high_score = score
		$HUD.update_highscore(high_score)

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	# Schwierigkeit zurücksetzten
	$MobTimer.wait_time = 0.5

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	# BONUS: Schwierigkeit erhöhen
	if $MobTimer.wait_time > 0.2:
		$MobTimer.wait_time -= 0.01

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# neue Instanz
	var mob = mob_scene.instantiate()

	# random platz 
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# random platz
	mob.position = mob_spawn_location.position

	# Richtung des Gegners senkrecht
	var direction = mob_spawn_location.rotation + PI / 2

	# Richtung etwas Zufall hinzufügen
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Geschwindigkeit für den Gegner
	# BONUS: Schwierigkeit erhöhen nach Zeit
	var min_speed = 150.0 + (score * 2)
	var max_speed = 250.0 + (score * 5)
	var velocity = Vector2(randf_range(min_speed, max_speed), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Erzeuge den Gegner
	add_child(mob)
