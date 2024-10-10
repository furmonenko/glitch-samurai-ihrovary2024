extends Cutscene

func advance_text(step: int):
	text_timer.start()
	
	match step:
		0:
			intro_text.text = "You prove yourself pretty usefull"
		1:
			intro_text.text = "But this is only a beggining"
		2:
			intro_text.text = "We need to reclaim Victoria"
			animation_player.play("fade_in")
