extends Cutscene

@onready var glitch_effects = $GlitchEffects
@onready var end_game = $EndGame


func _ready():
	super()
	
	end_game.visible = false
	

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
	intro_text.visible = false
	how_to_skip_container.visible = false
	glitch_effects.visible = false
	end_game.visible = true
	
	
