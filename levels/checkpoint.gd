extends Area2D

signal start_event



func _on_area_entered(area):
	start_event.emit()
