@tool
extends State

# when StateAutomaticTimer timeout()
func _state_timeout():
	if !target.in_cutscene:
		change_state("CanDash")
