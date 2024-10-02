extends Node2D

@export var death_scene: PackedScene
@export var next_scene: PackedScene

@onready var player_controller: PlayerController = $Characters/PlayerController
@onready var enemies = $Enemies



# Called every frame. 'delta' is the elapsed time since the previous frame.


func on_player_died():
	if death_scene:
		await get_tree().create_timer(0.5).timeout
		var instance = death_scene.instantiate()
		get_parent().add_child(instance)
		queue_free()
		


func _on_last_door_body_entered(body):
	if next_scene:
		await get_tree().create_timer(0.5).timeout
		var instance = next_scene.instantiate()
		get_parent().add_child(instance)
		queue_free()
