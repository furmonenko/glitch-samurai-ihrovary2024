extends Cutscene

func advance_text(step: int):
	text_timer.start()
	
	match step:
		0:
			intro_text.text = "Morning, customer. Good or bad, depends on what you're buying today"
		1:
			intro_text.text = "Ya' need to recharge, eh? We can do that, for resonable price of cource"
		2:
			intro_text.text = "Good luck, I suppose you need that. On me"
			animation_player.play("fade_in")
