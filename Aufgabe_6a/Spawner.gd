extends Node2D

# Der Pfad zur Szene des Gegners, den wir spawnen wollen.
@export var enemy_scene : PackedScene = preload("res://Abgaben/Aufgabe_6a/Enemy.tscn")

# Die Patrouillen-Punkte, die wir dem frisch gespawnten Gegner mitgeben.
@export var patrol_points_for_enemies : Array[Vector2] = [Vector2(50, 50), Vector2(400, 50)]

# Spawnt einen neuen Gegner und setzt seine Startwerte.
func spawn_enemy():
	# Gegner-Szene instanziieren.
	var enemy = enemy_scene.instantiate()
	
	# Den Gegner an der Position dieses Spawners platzieren.
	enemy.position = position
	
	# Dem Gegner seine Patrouillen-Punkte übergeben.
	enemy.patrol_points = patrol_points_for_enemies
	
	# Den Gegner der aktuellen Hauptszene hinzufügen.
	get_parent().add_child(enemy)


