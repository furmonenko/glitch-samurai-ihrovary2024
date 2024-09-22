extends Node2D
@onready var cutscene_music = $Cutscene_Music


func _process(delta):
	if !cutscene_music.playing:
		cutscene_music.play()
