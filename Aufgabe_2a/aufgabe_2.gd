extends Node2D

@onready var area1 = $Area1
@onready var area2 = $Area2
@onready var area3 = $Area3

func _process(delta):
	area1.rotation += delta
	area2.rotation += delta
	area3.rotation += delta

func _input(event):
	if event.is_action_pressed("action_1"):
		area1.modulate = Color(randf(), randf(), randf())
	if event.is_action_pressed("action_2"):
		area2.modulate = Color(randf(), randf(), randf())
	if event.is_action_pressed("action_3"):
		area3.modulate = Color(randf(), randf(), randf())
