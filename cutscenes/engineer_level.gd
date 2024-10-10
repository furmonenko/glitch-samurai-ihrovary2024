extends Cutscene


func advance_text(step: int):
	text_timer.start()
	
	match step:
		0:
			intro_text.text = "Now then, before you go on the surface"
		1:
			intro_text.text = "The Red Widow is waiting for you"
		2:
			intro_text.text = "Proove yourself. Destroy the beast"
		3:
			intro_text.text = "I'll recharge you before the figt. Good luck"
		4:
			intro_text.text = ""
			animation_player.play("fade_in")
