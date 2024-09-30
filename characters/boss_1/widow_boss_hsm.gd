extends StateMachine
class_name WidowBossStateMachine


func create_state_conditions():
	super()
	state_conditions["attack_strong"] = "parameters/conditions/attacking_strong"
	state_conditions["buff"] = "parameters/conditions/buff"
