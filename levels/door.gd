extends Node2D
class_name Door

@onready var control_panel = $ControlPanel
@onready var control = $ControlPanel/Control
@onready var animation_player = $AnimationPlayer

var is_door_opened = false

func _ready():
	control.visible = false
	control.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	if control.process_mode == Node.PROCESS_MODE_ALWAYS and !is_door_opened:
		if Input.is_action_just_pressed("activate"):
			animation_player.play("default")
			is_door_opened = true

func _on_area_2d_body_entered(body):
	control.visible = true
	control.process_mode = Node.PROCESS_MODE_ALWAYS



func _on_area_2d_body_exited(body):
	control.visible = false
	control.process_mode = Node.PROCESS_MODE_DISABLED
