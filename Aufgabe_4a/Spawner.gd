extends Node2D

# Der Pfad zur Gegner-Szene
@export var enemy_scene : PackedScene = preload("res://Abgaben/Aufgabe_4a/Enemy.tscn")

# Patrouillen-Punkte
@export var patrol_points_for_enemies : Array[Vector2] = [Vector2(50, 50), Vector2(400, 50)]

func spawn_enemy():
	# Gegner instanziieren
	var enemy = enemy_scene.instantiate()
	
	# Position des Spawners nutzen
	enemy.position = position
	
	# Patrouillen-Werte übergeben
	enemy.patrol_points = patrol_points_for_enemies
	
	# Der Szene hinzufügen
	get_parent().add_child(enemy)


