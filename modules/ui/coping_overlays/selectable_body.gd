extends Node2D

@onready var line2d := $Line2D
@onready var colorrect := $ColorRect

signal mouse_entered

func _on_mouse_entered() -> void:
	colorrect.hide()
	line2d.show()


func _on_color_rect_mouse_entered() -> void:
	colorrect.hide()
	line2d.show()
	mouse_entered.emit()
