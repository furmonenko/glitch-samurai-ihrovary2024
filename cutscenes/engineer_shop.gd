extends Cutscene

func faded_in():
	next_scene = load("res://levels/base_level.tscn")
	super()

func advance_text(step: int):
	text_timer.start()
	
	match step:
		0:
			intro_text.text = "Oh, back already? Guess you overdid it with the glitch, huh?"
		1:
			intro_text.text = "No worries, recharging is the name of the game. Even the best swords need sharpening sometimes"
		2:
			intro_text.text = "Sit tight, I’ll get you patched up. Hopefully, next time you won’t burn through it all like now"
		3:
			intro_text.text = "Recharge Stage"
		4:
			intro_text.text = ""
			animation_player.play("fade_in")
