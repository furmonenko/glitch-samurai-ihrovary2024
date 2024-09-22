extends Node2D

@onready var portal_1 = $Portal1
@onready var portal_2 = $Portal2
@onready var portal_1_spawn = $Portal1/portal1spawn
@onready var portal_2_spawn = $Portal2/portal2spawn


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_portal_1_body_entered(body):
	body.global_position = portal_2_spawn.global_position
	



func _on_portal_2_body_entered(body):
	body.global_position = portal_1_spawn.global_position
