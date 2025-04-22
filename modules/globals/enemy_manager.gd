extends Node

## The number of enemies allowed to run towards the player at one single time
const MAX_ENGAGERS = 2

## The number of enemies allowed to target the player with projectile attacks
const MAX_TARGETERS = 1

var current_engagers : Array[CharacterBody2D] = []
var marked_for_disengage : Dictionary[CharacterBody2D, Timer] = {}

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
		#timer.timeout.disconnect(release_engagement)
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
	timer.timeout.connect(release_engagement.bind(enemy, timer), CONNECT_ONE_SHOT)
	get_tree().current_scene.add_child(timer)
	timer.start(randf_range(1.0, 3.0))
	marked_for_disengage.set(enemy, timer)
