@tool
extends State


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# when StateAutomaticTimer timeout()
func _state_timeout():
	change_state("CanDash")
