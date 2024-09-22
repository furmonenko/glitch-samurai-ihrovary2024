extends Node2D

@export var death_scene: PackedScene

@onready var scene_glitch = $SceneGlitch
@onready var player_controller = %PlayerController

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_glitch.animation_player.play("scene_glitch")
	
	player_controller.dead.connect(func():
		scene_glitch.animation_player.play("scene_glitch")
		on_player_died()
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_player_died():
	if death_scene:
		await get_tree().create_timer(0.5).timeout
		var instance = death_scene.instantiate()
		get_parent().add_child(instance)
		queue_free()
		
