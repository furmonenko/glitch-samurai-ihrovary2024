extends Node2D
class_name Level

@export var next_scene: PackedScene
@export var level_idx: int = 0
@export var last_door: LastDoor

func _ready():	
	
	if last_door:
		last_door.on_yes_pressed.connect(func():
			if next_scene:
				var instance = next_scene.instantiate()
				get_parent().add_child(instance)
				queue_free()
			)
