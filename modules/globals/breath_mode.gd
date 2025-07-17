extends ColorRect 

@onready var time_remaining : Label = $TimeRemaining
@onready var timer : Timer = $Timer
@export var deadeye_time := 10.0
signal done

var current_selectables : Array[Node2D]
var current_bodies_selected : Array[TetherableBody]
var tutorial_bodies : Array[Node]
var main_body_selected

var selectable_body_selector : PackedScene = preload("res://modules/ui/coping_overlays/selectable_body.tscn")
var yarn_controller_packed : PackedScene = preload("res://modules/entities/player/yarn/yarn_controller.tscn")
var first_tetherable : TetherableBody

# Used for path comparison in coping mechanism
var boss_path = "res://modules/entities/enemies/shades/school_boss/school_boss.tscn"
var hand_path = "res://modules/entities/enemies/shades/school_boss/school_boss_hands.tscn"

func _on_visibility_changed() -> void:
	if visible:
		if is_inside_tree():
			get_tree().paused = true
	else:
		if is_inside_tree():
			get_tree().paused = false
			_yank_all_yarn()

func _process(_delta: float) -> void:
	if visible:
		time_remaining.text = "%.2f" % [timer.time_left]

func start_mode(timer_override:bool = false):
	current_selectables.clear()
	current_bodies_selected.clear()
	
	if !timer_override:
		timer.start(deadeye_time)
		time_remaining.show()
	else:
		time_remaining.text = "10.0"
		time_remaining.show()
	
	# Intended logic:
	# 1. For each TetherableBody shown on screen, create a GUI element as a child of BreathMode \
	# \ that can be selected with mouse hover.
	# 2. Keep a list (ordered) with each tetherablebody that has been "tagged"
	# 3. Tether all TetherableBodies to the first element in the list
	# 4. Call pull (or fling?) on all bodies (Ideally pulling all to the center point / first element)
	# 5. If Shades are pulled together, they create a "Shade Wrap" -- a body \
	# \ that keeps track of how many shades are inside of it, and when struck, explodes them out 
	# \ and does massive damage.
	# 6. If breakables are pulled into Shades or Shade piles, break the breakable and damage
	for body : TetherableBody in get_tree().get_nodes_in_group("tetherable_body"):
		# Don't include ramen in this list
		if body.is_in_group("ramen_body"):
			continue
		
		# Generate UI element that can be selected with mouse hover
		var selector : Node2D = selectable_body_selector.instantiate()
		
		# Add under canvaslayer that excludes the grayscale-filter
		get_parent().get_parent().get_node("ScreenFXExclusion").add_child(selector)
		
		if body in tutorial_bodies:
			selector.pointer.show()
		
		selector.global_position = body.global_position
		selector.mouse_entered.connect(select_body.bind(body, selector))
		
		# Add to list to free when done
		current_selectables.append(selector)

func select_body(body : TetherableBody, selector):
	current_bodies_selected.append(body)
	
	if current_bodies_selected.size() == 1:
		selector.line2d.set_indicator(true)
	elif current_bodies_selected.size() > 1:
		var direction_to_main = body.global_position.direction_to(current_bodies_selected[0].global_position)
		selector.line2d.set_indicator(false, direction_to_main)

	if body in tutorial_bodies:
		tutorial_bodies.erase(body)
		if tutorial_bodies.is_empty():
			deadeye_timeout()

func _on_timer_timeout() -> void:
	deadeye_timeout()

func deadeye_timeout():
	done.emit()
	
	# Set time to equal the default time so it doesn't visibly jump from 0.00 to time when shown
	time_remaining.text = "%.2f" % [deadeye_time]
	time_remaining.hide()
	
	_set_yarn()
	
	# remove all selectors for nodes
	for node in current_selectables:
		node.queue_free()
	
	hide()

func _set_yarn():
	first_tetherable = current_bodies_selected.pop_at(0)
	
	for selected_tether in current_bodies_selected:
		# Prevents tethering with a hand as leash owner
		if first_tetherable.scene_file_path == hand_path:
			return
		
		# Prevents boss from being tethered to other shades
		if selected_tether.scene_file_path == boss_path:
			continue
		
		# Make a new instance of visual yarn, end point set to this tetherbody
		var yarn = yarn_controller_packed.instantiate()
		yarn.can_collide = false
		yarn.tethered_body = selected_tether
		selected_tether.yarn_instance = yarn
		
		# Set the pull target for all other ones
		selected_tether.leash_owner = first_tetherable
		
		# Set the start point of the yarn to be the first tetherbody selected
		# (This makes all nodes selected become yanked to the first one)
		first_tetherable.add_child(yarn)

func _yank_all_yarn():
	for selected_tether in current_bodies_selected:
		selected_tether.fling()
		
func update_tethers_to_cocoon(cocoon):
	for selected_tether in current_bodies_selected:
		selected_tether.leash_owner = cocoon
