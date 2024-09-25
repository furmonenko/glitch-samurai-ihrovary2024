extends StateMachine
class_name HellbotMachine

func create_state_conditions():
	super()
	state_conditions["shoot"] = "parameters/conditions/shooting"
