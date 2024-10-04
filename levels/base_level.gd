extends Node2D

@export var next_scene: PackedScene

@onready var player_controller: PlayerController = $Characters/PlayerController
@onready var enemies = $Enemies
@onready var last_door = $LastDoor

func _ready():
	last_door.on_yes_pressed.connect(func():
		if next_scene:
			var instance = next_scene.instantiate()
			get_parent().add_child(instance)
			queue_free()
		)
