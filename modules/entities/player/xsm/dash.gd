@tool
extends StateSound

@export var dash_speed := 400
@export var dash_distance := 128
var dash_direction := Vector2()
var start_location := Vector2()
var distance_travelled := 0
var walled : bool

@onready var dash_states : Dictionary = {
	Vector2.UP: "dash_up", 
	Vector2.RIGHT: "dash",
	Vector2.DOWN: "dash_down",
	Vector2.LEFT: "dash_left"
	}

var dust_anims : Dictionary = {
	Vector2.UP: "up", 
	Vector2(-1, -1): "left_up",
	Vector2(1, -1): "right_up",
	Vector2.RIGHT: "right_down",
	Vector2(1, 1): "right_down",
	Vector2.DOWN: "down",
	Vector2(-1, 1): "left_down",
	Vector2.LEFT: "left_down",
}

@export var dash_shadow : Texture2D
@export var normal_shadow : Texture2D

var dash_dust : PackedScene = preload("res://modules/entities/player/dash_dust.tscn")
var idle_dir

#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

func _on_enter(_args):
	change_state("NoAttack")
	
	start_location = target.global_position
	# TODO: when implementing controller, override this with analog stick direction instead of mouse pos
	var mouse_pos = target.get_global_mouse_position()
	dash_direction = start_location.direction_to(mouse_pos).normalized()
	distance_travelled = 0
	
	# this logic is so that we find which of the four cardinals our mouse is \
	# closest to. whichever absolute value is larger determines which \
	# component (x or y) we want to take as the main value.
	var component_x = abs(dash_direction.x)
	var component_y = abs(dash_direction.y)
	
	var swing_dir = dash_direction
	
	# if juni has no hook, play no hook animations
	var no_hook = ""
	if target.hook_locked:
		no_hook = "no_spear/"
		
	var dust_dir = swing_dir.snapped(Vector2.ONE)
	
	if component_x > component_y:
		swing_dir.y = 0
	if component_y > component_x:
		swing_dir.x = 0
	
	# .snapped(Vector2.ONE) would normally round to the nearest of the 
	# 8 cardinal dirs, but since we got rid of the non-major component it will
	# only be the 4 main cardinals (up, down, left, right)
	swing_dir = swing_dir.snapped(Vector2.ONE)

	target.swing_dir = swing_dir
	# our four cardinals are:
	# UP: (0,-1)
	# RIGHT: (1,0)
	# DOWN: (0, 1)
	# LEFT: (-1, 0)
	# the dictionary initialized at the top of this script assigns each vector2
	# value to the corresponding state node name
	
	var dust = dash_dust.instantiate()
	get_tree().current_scene.add_child(dust)
	dust.global_position = target.global_position
	dust.play(dust_anims[dust_dir])
	
	idle_dir = swing_dir
	play(no_hook + dash_states[swing_dir])

func _on_update(_delta):
	target.velocity = dash_direction * dash_speed
	distance_travelled = distance_travelled + (target.velocity * _delta).length()

func _after_update(_delta):
	if distance_travelled >= dash_distance:
		target.velocity = Vector2.ZERO
		change_state("Idle", idle_dir)

func _on_exit(_args):
	target.velocity = Vector2.ZERO
	change_state("DashTimer")
