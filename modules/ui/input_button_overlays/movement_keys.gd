extends Node2D

@onready var w = $W
@onready var a = $A
@onready var s = $S
@onready var d = $D
@onready var space = $SpaceBar

var w_y := 35.0
var a_y := 52.0
var s_y := 52.0
var d_y := 52.0
var space_y := 97.0

var w_read := false
var a_read := false
var s_read := false
var d_read := false
var space_read := false

var tutorial_started := false
var key_update_counter = 0.0

func start_tutorial():
	tutorial_started = true
	w.show()
	a.show()
	s.show()
	d.show()
	space.show()
	check_completeness()

func _input(event: InputEvent):
	if !tutorial_started:
		return
	
	if event.is_action_pressed("move_up"):
		press_w()
	if event.is_action_pressed("move_left"):
		press_a()
	if event.is_action_pressed("move_down"):
		press_s()
	if event.is_action_pressed("move_right"):
		press_d()
	if event.is_action_pressed("dash"):
		press_space()

func press_w():
	if w_read:
		return
	w_read = true
	w_y = 171
	key_update_counter += 1
	check_completeness()

func press_a():
	if a_read:
		return
	a_read = true
	a_y = 188
	key_update_counter += 1
	check_completeness()

func press_s():
	if s_read:
		return
	s_read = true
	s_y = 188
	key_update_counter += 1
	check_completeness()

func press_d():
	if d_read:
		return
	d_read = true
	d_y = 188
	key_update_counter += 1
	check_completeness()

func press_space():
	if space_read:
		return
	space_read = true
	space_y = 225
	key_update_counter += 1
	check_completeness()

func check_completeness():
	w.texture.region = Rect2(307.0, w_y, 13.0, 14.0)
	a.texture.region = Rect2(307.0, a_y, 13.0, 14.0)
	s.texture.region = Rect2(324.0, s_y, 13.0, 14.0)
	d.texture.region = Rect2(341.0, d_y, 13.0, 14.0)
	space.texture.region = Rect2(497.0, space_y, 46.0, 14.0)
	
	if key_update_counter == 5:
		$Timer.start()

func _on_timer_timeout():
	tutorial_started = false
	key_update_counter = 0.0
	
	w_y = 35.0
	a_y = 52.0
	s_y = 52.0
	d_y = 52.0
	space_y = 97.0
	
	w.hide()
	a.hide()
	s.hide()
	d.hide()
	space.hide()
	
	check_completeness()
