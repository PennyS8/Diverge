extends CharacterBody2D
# All the logic is handled by the xsm below
# Even variables have now been moved to states
# Player keeps it own velocity, as well as vars
# that can be used by many different states


# var velocity := Vector2()
var dir := 0
var wall_dir := 0

@onready var skin = get_node("Skin")

enum {TOP_FRONT, MIDDLE_FRONT, BOTTOM_FRONT, BOTTOM}


func _ready():
	$"%CanDash".disabled = true


func ray(ray_dir, goal, length_factor):
	var aiming_position = global_position
	
	match goal:
		TOP_FRONT:
			aiming_position.x += length_factor * ray_dir * $Body.shape.extents.x
			aiming_position.y -= length_factor * $Body.shape.extents.y
		MIDDLE_FRONT:
			aiming_position.x += length_factor * ray_dir * $Body.shape.extents.x
		BOTTOM_FRONT:
			aiming_position.x += length_factor * ray_dir * $Body.shape.extents.x
			aiming_position.y += length_factor * $Body.shape.extents.y
		BOTTOM:
			aiming_position.y += length_factor * $Body.shape.extents.y

	var query = PhysicsRayQueryParameters2D.create(global_position, aiming_position)
	return get_world_2d().direct_space_state.intersect_ray(query)			


func detect_wall_dir():
	var raysult1 = ray(skin.scale.x, MIDDLE_FRONT, 1.5)
	var raysult2 = ray(skin.scale.x, BOTTOM_FRONT, 1.5)
	var raysult3 = ray(skin.scale.x, TOP_FRONT, 1.5)
	if raysult1.is_empty() and raysult2.is_empty() and raysult3.is_empty():
		wall_dir = - skin.scale.x
	else: 
		wall_dir = skin.scale.x


func _on_ShardArea2D_body_entered(body:Node):
	if body == self:
		var can_dash_state = $"%CanDash"
		can_dash_state.disabled = false
		can_dash_state.change_state()

		var sound = get_node("Sounds/ExplosionSound")
		sound.play()
		sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 5


func _on_EndArea2D_body_entered(body:Node):
	if body == self:
		$XSM.disabled = true
		hide()
		var sound = get_node("Sounds/ShipSound")
		sound.play()
		sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 5
