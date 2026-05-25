extends Area2D

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		modulate = Color(randf(), randf(), randf())
