extends CharacterBody2D

# All the logic is handled by the xsm below
# Even variables have now been moved to states
# Player keeps it own velocity, as well as vars that can be used by many different states

var dir : Vector2 = Vector2.ZERO

# swing_dir is a variable updated by our sword swing that gets the 
# nearest cardinal direction to our mouse click (n, e, s, w)
# we keep it in here to use it to push blocks in that direction
var swing_dir : Vector2

# if player is currently inside a "ledge" area, the reference to that is stored here
var ledge_collision : Area2D

var idleDirection

@onready var health_component = $HealthComponent
@onready var actionable_finder = $ActionableMarker2D/ActionableFinder

var lock_camera := false

func _process(_delta):
	_camera_move(_delta)
	#$Camera2D.global_position = round($Camera2D.global_position)
	pass

func _camera_move(_delta):
	if !lock_camera:
		$Camera2D.global_position = round(global_position + (get_global_mouse_position() - global_position) * 0.25)
		$Camera2D.position_smoothing_enabled = true
	else:
		$Camera2D.position_smoothing_enabled = false

func _on_sword_body_entered(body: Node2D) -> void:
	if body.is_in_group("block"):
		body.push(swing_dir)
	elif body.is_in_group("lever"):
		body.flip()
		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size()>0:
			actionables[0].action()
			return

func stop_movement()->void:
	var direction = $AnimationPlayer.current_animation
	direction = direction.get_slice("_", 1)
	idleDirection = "idle_" + direction
	get_node("PlayerFSM").change_state("MovementDisabled")
	var anim : Animation= $AnimationPlayer.get_animation(idleDirection)
	anim.loop_mode =(Animation.LOOP_LINEAR)
	$AnimationPlayer.play(idleDirection)


func start_movement()->void:
	var anim : Animation= $AnimationPlayer.get_animation(idleDirection)
	anim.loop_mode =(Animation.LOOP_NONE)
	get_node("PlayerFSM").change_state("Idle")
