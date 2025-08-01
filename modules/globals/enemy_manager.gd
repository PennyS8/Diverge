extends Node

## The number of enemies allowed to run towards the player at one single time
const MAX_ENGAGERS = 2

## The number of enemies allowed to target the player with projectile attacks
const MAX_TARGETERS = 1

## The number of hands the boss is allowed to have
const MAX_HANDS = 5

var current_engagers : Array[CharacterBody2D] = []
var marked_for_disengage : Dictionary[CharacterBody2D, Timer] = {}
var hand_spawn_counter : Dictionary[CharacterBody2D, Vector2] = {}
var boss_spawned_enemies : Array[CharacterBody2D] = []

#region VARIABLES - Ultimate Meter
var deep_breath_unlocked := false

## Private Variable - Represents the current state of the Ult Meter (# of enemies defeated)
var _focus_meter := 0

## When _meter is equal to MAX_METER, player can initialize deep breath
const MIN_METER := 0
const MAX_METER := 4

## Variable that keeps track of status of deep breath upon focus_meter's set
var can_deep_breath := false

## Signal that is emitted whenever focus_meter is updated
signal focus_updated(new_value)

## Public interface for _focus_meter that auto-clamps its values and handles  
var focus_meter: int:
	get:
		return _focus_meter
	set(value):
		if !deep_breath_unlocked:
			return
		
		_focus_meter = clamp(value, MIN_METER, MAX_METER)
		
		# Send this so UI can update
		focus_updated.emit(value)
		
		# Sets `can_deep_breath` based on meter's progress
		set_deep_breath_status()

## Sets `can_deep_breath` based on focus meter's progress
func set_deep_breath_status():
	if _focus_meter == MAX_METER:
		can_deep_breath = true
	else:
		can_deep_breath = false

func reset_focus_meter():
	focus_meter = 0
	can_deep_breath = false

#endregion

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

func release_engagement(enemy):
	if !enemy:
		return
	
	# search for timer object
	if marked_for_disengage.has(enemy):
		var timer = marked_for_disengage[enemy]
		timer.queue_free()
	else:
		if marked_for_disengage.has(enemy):
			marked_for_disengage[enemy].queue_free()
	
	if current_engagers.has(enemy):
		current_engagers.erase(enemy)
	
	if marked_for_disengage.has(enemy):
		marked_for_disengage.erase(enemy)

func mark_for_disengage(enemy : CharacterBody2D):
	# if we've already marked this enemy for disengagement, free its timer
	if marked_for_disengage.has(enemy):
		marked_for_disengage[enemy].timeout.disconnect(release_engagement)
		marked_for_disengage[enemy].queue_free()
	
	var timer := Timer.new()
	timer.one_shot = true
	timer.timeout.connect(release_engagement.bind(enemy), CONNECT_ONE_SHOT)
	get_tree().current_scene.add_child(timer)
	timer.start(randf_range(1.0, 3.0))
	marked_for_disengage.set(enemy, timer)

#region Boss Hand spawning / removing functions
func add_hand(hand : CharacterBody2D, spawn_location : Vector2):
	if !hand_spawn_counter.has(hand):
		hand_spawn_counter.set(hand, spawn_location)

func remove_hand(hand : CharacterBody2D):
	if hand_spawn_counter.has(hand):
		hand_spawn_counter.erase(hand)
		return true
	else:
		return false

func remove_all_hands():
	for enemy in hand_spawn_counter:
		# Sanity check to make sure enemy still exists
		if enemy:
			enemy.fsm.change_state("Death")
	
	hand_spawn_counter.clear()

# Checks if a new hand will overlap with an already existing hand
func check_overlapping_hands(new_hand_x : int, new_hand_y : int, margin : int) -> bool: 
	for hand in hand_spawn_counter:
		var hand_location = hand_spawn_counter[hand]
		var hand_x = hand_location.x
		var hand_y = hand_location.y
		
		if new_hand_x in range(hand_x-margin, hand_x+margin):
			return true
		
		if new_hand_y in range(hand_y-margin, hand_y+margin):
			return true
	
	# If we haven't found an overlap, return false
	return false
#endregion

#region Boss enemy spawning outside of hands
func add_boss_spawned_enemy(enemy : CharacterBody2D):
	if !boss_spawned_enemies.has(enemy):
		boss_spawned_enemies.append(enemy)

func remove_boss_spawned_enemy(enemy : CharacterBody2D):
	if boss_spawned_enemies.has(enemy):
		boss_spawned_enemies.erase(enemy)

func remove_boss_spawned_enemies():
	for enemy in boss_spawned_enemies:
		# Looks for enemies that are still spawned
		if enemy:
			enemy._on_health_component_died()
	
	boss_spawned_enemies.clear()
#endregion

func remove_marked_enemies():
	current_engagers.clear()
	marked_for_disengage.clear()
	hand_spawn_counter.clear()
	boss_spawned_enemies.clear()
