extends Node2D

@export var death_scene: PackedScene
@export var next_scene: PackedScene

@onready var scene_glitch = $SceneGlitch
@onready var player_controller: PlayerController = $Characters/PlayerController
@onready var glitch: ColorRect = $SceneGlitch/%Glitch
@onready var glitch_sound = $SceneGlitch/GlitchSound

# Called when the node enters the scene tree for the first time.
func _ready():
	if player_controller:
		player_controller.glitch_exited.connect(func():
			if scene_glitch:
				scene_glitch.animation_player.stop()
				scene_glitch.visible = false
				glitch_sound.playing = false
			)
	
	scene_glitch.animation_player.play("scene_glitch")
	
	player_controller.dead.connect(func():
		scene_glitch.animation_player.play("scene_glitch")
		on_player_died()
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player_controller.character:
		pass
	
	if player_controller.character.is_glitched:
		scene_glitch.animation_player.play("player_glitched")
		scene_glitch.visible = true

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
