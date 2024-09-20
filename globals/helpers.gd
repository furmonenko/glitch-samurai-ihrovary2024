extends Node

func throw_error(error_text :String, caller :String):
	print(error_text + caller + " script")
	get_tree().quit()
