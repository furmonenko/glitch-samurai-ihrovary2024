extends Cutscene

signal end_cutscene

@onready var glitch_effects = $GlitchEffects
@onready var last_demo_scene = $"."


func _ready():
	super()
	last_demo_scene.process_mode = Node.PROCESS_MODE_ALWAYS

func advance_text(step: int):
	text_timer.start()
	match step:
		0:
			intro_text.text = "Samurai"
		1:
			intro_text.text = "What did he do to you???"
		2:
			intro_text.text = "How dare you"
		3:
			intro_text.text = ""
			animation_player.play("fade_in")

func faded_in():
	end_cutscene.emit()
	queue_free()
	
	
