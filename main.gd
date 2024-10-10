extends Node2D
@onready var cutscene_music = $Cutscene_Music
@onready var current_scene_parent = $CurrentScene

@export var level_dict: Dictionary
@export var death_scene: PackedScene

var current_scene

func _ready():
	
	
	Helpers.character_died.connect(func(value):
		current_scene = current_scene_parent.get_child(0)
		current_scene.queue_free()
		
		var death_scene_inst = death_scene.instantiate()
		current_scene_parent.add_child(death_scene_inst)
		death_scene_inst.given_string = level_dict[value]
		
		)
	
func _process(delta):
	if !cutscene_music.playing:
		cutscene_music.play()
	
