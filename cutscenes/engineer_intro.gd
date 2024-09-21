extends Cutscene

func advance_text(step: int):
	text_timer.start()
	
	match step:
		0:
			intro_text.text = "I hardly recognize you... but that doesn’t matter"
		1:
			intro_text.text = "The Senator told me about the changes. You’re different now, stronger. And I know what I need to do"
		2:
			intro_text.text = "Listen closely. You have a new ability called 'glitch.' When you activate it, you become untouchable"
		3:
			intro_text.text = "You move faster than anyone can see, you can fly, and pass through obstacles"
		4:
			intro_text.text = "But there's a catch: in this state, you can’t attack. You’re invulnerable, but harmless"
		5:
			intro_text.text = "Remember, using the glitch drains your energy. When it's depleted, you're vulnerable. You'll need to come back to me to recharge"
		6:
			intro_text.text = "Are you ready? It's time to master your new power"
		7:
			intro_text.text = "[ARROWS] - move, [SPACE] - attack, [F] - glitch on/off"
		8:
			intro_text.text = "Recharging stage."
		9:
			intro_text.text = "Go now, do what you're supposed to do"
			animation_player.play("fade_in")
