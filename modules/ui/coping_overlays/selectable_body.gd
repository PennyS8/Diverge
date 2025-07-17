extends Node2D

@onready var line2d := $Line2D
@onready var pointer := $Pointer
@onready var colorrect := $ColorRect

var locked_in := false

signal mouse_entered

func _process(_delta: float) -> void:
	if !locked_in:
		var mouse_point = global_position - get_global_mouse_position()
		var numerator = max(mouse_point.length() - 24.0, 0)
		var denom = 144 - 24.0
		var magnitude = (numerator / denom) * 12.5
		var mouse_scaled = mouse_point.normalized() * magnitude
		colorrect.set_instance_shader_parameter("r_displacement", Vector2(mouse_scaled.x, mouse_scaled.y))
		colorrect.set_instance_shader_parameter("g_displacement", Vector2(-mouse_scaled.x, -mouse_scaled.y))
		colorrect.set_instance_shader_parameter("b_displacement", Vector2(0, mouse_scaled.y))

func _on_control_mouse_entered() -> void:
	$MouseDetector.hide()
	colorrect.hide()
	line2d.show()
	pointer.hide()
	locked_in = true
	mouse_entered.emit()
