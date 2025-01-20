extends StatusEffectsClass

@onready var player = get_tree().get_first_node_in_group("player")
@onready var self_object = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	select()

func _on_area_2d_mouse_exited() -> void:
	deselect()

func select():
	if get_parent().is_in_group("status_tethered"):
		return
	get_parent().add_to_group("selected")
	get_parent().modulate = Color(255, 255, 0, 0.5)

func deselect():
	get_parent().remove_from_group("selected")
	get_parent().modulate = Color(255, 255, 255, 1)

# Retracts the length of the thread, pulling the tethered node to the fling point
# TODO: replace tween position with a force on body in dir
func fling_tethered_node(fling_point : Vector2):
	if !get_parent().is_in_group("status_tethered"):
		return
	var end_point = global_position.lerp(fling_point, 0.8)

	var tween = get_tree().create_tween()
	tween.tween_property(self_object, "global_position", end_point, 0.25)
	
	remove_status("Tethered")
