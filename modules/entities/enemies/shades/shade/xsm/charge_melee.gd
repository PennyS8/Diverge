@tool
extends StateAnimation

## THIS STATE EXITS BASED ON THE CONDITIONS OF THE TIMER ATTACHED TO IT.
## WE POSSIBLY WANT TO PASS THIS IN AS A PARAMETER OR SOMETHING. THE TIMER IS FOR DEBUG.
## I LOVE YOU.

func _on_anim_finished():
	change_state("Melee")

func _on_exit(_args):
	play("RESET")
