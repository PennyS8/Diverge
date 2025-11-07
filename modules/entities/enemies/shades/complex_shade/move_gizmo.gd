extends Node2D

@export var ai_steering_owner : Node2D
var ai_steering : AISteering
var gizmo_rays : Dictionary[RayCast2D, Vector2]

# Called when the node enters the scene tree for the first time.
func _ready():
	if "ai_steering" in ai_steering_owner:
		ai_steering = ai_steering_owner.ai_steering
		
		for i in range(ai_steering.context.size()):
			var new_ray = RayCast2D.new()
			var dir = ai_steering.get_normal(i)
			# disable collision, we merely want to use this for its nice arrow
			new_ray.set_collision_mask_value(1, false)
			new_ray.target_position = dir
			gizmo_rays.set(new_ray, dir)
			add_child(new_ray)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !ai_steering:
		if "ai_steering" in ai_steering_owner:
			ai_steering = ai_steering_owner.ai_steering
			
			for i in range(ai_steering.context.size()):
				var new_ray = RayCast2D.new()
				var dir = ai_steering.get_normal(ai_steering.context[i])
				# disable collision, we merely want to use this for its nice arrow
				new_ray.set_collision_mask_value(1, false)
				new_ray.target_position = dir*10.0
				gizmo_rays.set(new_ray, dir)
				add_child(new_ray)
	
	for i in range(gizmo_rays.keys().size()):
		var ray = gizmo_rays.keys()[i]
		ray.target_position = gizmo_rays[ray] * ai_steering.context[i] * 200.0
		
