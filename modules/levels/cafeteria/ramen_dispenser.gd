extends Node2D

@export var ramen_item : PackedScene

var lunch_shady_left : bool = false

func dispense(point, wanderer_spawn):
	var ramen_instance : Node2D = ramen_item.instantiate()
	ramen_instance.name = "Ramen" + point.name
	ramen_instance.spawns_wanderer = wanderer_spawn
	point.add_child(ramen_instance)

func _on_debug_area_body_entered(body: Node2D) -> void:
	LevelManager.player.enter_cutscene($CameraLock.global_position)
	var dispense_points = $DispensePoints.get_children()
	for point in dispense_points:
		point.spawns_wanderer = true
	var disabled_id = randi_range(0,4)
	var disabled_area = dispense_points[disabled_id]
	disabled_area.spawns_wanderer = false
	
	var tween = create_tween()
	if lunch_shady_left == true:
		$LunchShady/AnimatedSprite2D.play("dash_right")
		tween.tween_property($LunchShady, "global_position", $LunchShady.global_position+Vector2(170,0), 1)
		lunch_shady_left = false
	else:
		$LunchShady/AnimatedSprite2D.play("dash_left")
		tween.tween_property($LunchShady, "global_position", $LunchShady.global_position-Vector2(170,0), 1)
		lunch_shady_left = true
		
func _on_dispense_point_area_entered(area : Node2D, num : int) -> void:
	var point = get_node("DispensePoints/DispensePoint" + str(num))
	call_deferred("dispense", point, point.spawns_wanderer)
