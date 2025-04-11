extends ColorRect

@onready var time_remaining : Label = $TimeRemaining
@onready var timer : Timer = $Timer

signal done

func _on_visibility_changed() -> void:
	if visible:
		timer.start(2.0)
		get_tree().paused = true
		
func _process(delta: float) -> void:
	if visible:
		time_remaining.text = "%.2f" % [timer.time_left]


func _on_timer_timeout() -> void:
	get_tree().paused = false
	done.emit()
	hide()
