extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$FogOfWar.uncover_sphere(event.position, 100)
