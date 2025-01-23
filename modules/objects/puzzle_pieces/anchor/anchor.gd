extends StaticBody2D

@export var key_id := 0
@export var toggled := false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var status_holder = get_node("StatusHolder")

# Retracts the length of the thread, pulling the player to the anchor 
# TODO: replace tween position with a force on body in dir
func pull_player():
	if !is_in_group("status_tethered"):
		return
	
	var player_pos = player.global_position
	var end_point = player_pos.lerp(self.global_position, 0.6)
	
	var tween = get_tree().create_tween()
	tween.tween_property(player, "global_position", end_point, 0.2)
	
	status_holder.remove_status("Tethered")

func fling(fling_point : Vector2):
	pass
	#var fling_dir = global_position.direction_to(fling_point).normalized()
	#var component_x = abs(fling_dir.x)
	#var component_y = abs(fling_dir.y)
	## if the lever is being pulled left or right enough to be flipped
	#if abs(fling_dir.x) > abs(fling_dir.y):
		## if lever is right and pulled left, or if lever is left and pulled right, flip the lever
		#if toggled and fling_dir.x > 0 or !toggled and fling_dir.x < 0:
			#flip() # if lever is right and pulled left, flip
	#
	#if get_node("StatusHolder").get_node("Tethered"):
		#get_node("StatusHolder").remove_status("Tethered")

func pull():
	pass
	#var player =  get_tree().get_nodes_in_group("player")[0]
	#var player_pos = player.global_position + Vector2(0, -8)
	#var pull_dir = global_position.direction_to(player_pos).normalized()
	#var new_pos = global_position + pull_dir*THREAD_LENGTH + Vector2(0, 8)
	#player.global_position = new_pos
	#
	## this logic is so that we find which of the four cardinals our mouse is \
	## closest to. whichever absolute value is larger determines which \
	## component (x or y) we want to take as the main value.
	#var component_x = abs(pull_dir.x)
	#var component_y = abs(pull_dir.y)
	## if the lever is being pulled left or right enough to be flipped
	#if abs(pull_dir.x) > abs(pull_dir.y):
		## if lever is right and pulled left, or if lever is left and pulled right, flip the lever
		#if toggled and pull_dir.x > 0 or !toggled and pull_dir.x < 0:
			#flip()
			#if get_node("StatusHolder").get_node("Tethered"):
				#get_node("StatusHolder").remove_status("Tethered")
