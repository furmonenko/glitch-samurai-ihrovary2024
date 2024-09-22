extends CanvasLayer

@onready var pause = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	pause.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause.visible = !pause.visible
	

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()


func _on_texture_button_2_pressed():
	toggle_pause()


func _on_texture_button_pressed():
	get_tree().quit()
