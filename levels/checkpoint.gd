extends Area2D

signal start_event

@onready var collision_shape_2d = $CollisionShape2D


func _on_area_entered(area):
	start_event.emit()
