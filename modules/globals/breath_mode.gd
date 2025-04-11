extends ColorRect 

@onready var time_remaining : Label = $TimeRemaining
@onready var timer : Timer = $Timer
@export var deadeye_time := 10.0
signal done

func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
	else:
		get_tree().paused = false

func _process(delta: float) -> void:
	if visible:
		time_remaining.text = "%.2f" % [timer.time_left]

func start_mode():
	timer.start(deadeye_time)
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
	
	
func _on_timer_timeout() -> void:
	done.emit()
	
	# Set time to equal the default time so it doesn't visibly jump from 0.00 to time when shown
	time_remaining.text = "%.2f" % [deadeye_time]

	time_remaining.hide()
	hide()
