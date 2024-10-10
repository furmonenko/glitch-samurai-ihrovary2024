extends Area2D
class_name LastDoor
@onready var control = $Control
@onready var yes = $Control/Yes

signal on_yes_pressed

func _ready():
	control.visible = false
	control.process_mode = Node.PROCESS_MODE_DISABLED
	
func _process(delta):
	if control.process_mode != Node.PROCESS_MODE_DISABLED:
		if Input.is_action_just_pressed("activate"):
			_on_yes_pressed()



func _on_yes_pressed():
	on_yes_pressed.emit()



func _on_body_entered(body):
	control.visible = true
	control.process_mode = Node.PROCESS_MODE_ALWAYS


func _on_body_exited(body):
	control.visible = false
	control.process_mode = Node.PROCESS_MODE_DISABLED
