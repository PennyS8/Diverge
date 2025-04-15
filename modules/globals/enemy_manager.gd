extends Node

## The number of enemies allowed to run towards the player at one single time
const MAX_ENGAGERS = 2

## The number of enemies allowed to target the player with projectile attacks
const MAX_TARGETERS = 1

## The number of hands the boss is allowed to have
const MAX_HANDS = 1

var current_engagers : Array[CharacterBody2D] = []
var marked_for_disengage : Dictionary[CharacterBody2D, Timer] = {}
var hand_spawn_counter : Dictionary[CharacterBody2D, Vector2] = {}

## If an enemy wishes to engage the player, make sure they can
func request_engagement(enemy : CharacterBody2D):
	if current_engagers.has(enemy):
		return false
	
	if marked_for_disengage.has(enemy):
		return false
	
	if current_engagers.size() < MAX_ENGAGERS:
		current_engagers.append(enemy)
		return true
	return false

func release_engagement(enemy : CharacterBody2D, timer : Timer = null):
	if timer:
		timer.queue_free()
	
	if current_engagers.has(enemy):
		current_engagers.erase(enemy)
	
	if marked_for_disengage.has(enemy):
		marked_for_disengage.erase(enemy)

func mark_for_disengage(enemy : CharacterBody2D):
	# if we've already marked this enemy for disengagement, free its timer
	if marked_for_disengage.has(enemy):
		marked_for_disengage[enemy].queue_free()
	
	var timer := Timer.new()
	timer.one_shot = true
	timer.timeout.connect(release_engagement.bind(enemy, timer), CONNECT_ONE_SHOT)
	get_tree().current_scene.add_child(timer)
	timer.start(randf_range(1.0, 3.0))
	marked_for_disengage.set(enemy, timer)

func add_hand(hand : CharacterBody2D, spawn_location : Vector2):
	if hand_spawn_counter.size() < MAX_HANDS:
		hand_spawn_counter.set(hand, spawn_location)

func remove_hand(hand : CharacterBody2D):
	if hand_spawn_counter.has(hand):
		hand_spawn_counter.erase(hand)
		return true
	else:
		return false

func remove_all_hands():
	hand_spawn_counter.clear()
