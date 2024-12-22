extends Node2D

#
# Class Status defines the functionalities of ALL status effects.
# The functions in this class are overwritten by each status effect node
# added to the status holder node of the node that is affected.
#
class_name Status


func _ready() -> void:
	print("DEBUG: Custom class Status started")


func get_tethered():
	return null


func get_stunned():
	return null


func get_fucked_lol():
	return null
