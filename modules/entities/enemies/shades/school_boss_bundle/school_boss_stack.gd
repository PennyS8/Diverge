extends TetherableBody

@export var shade_healths_stored : Array[int]
@export var enemy_types_stored : Array[String]

@onready var sprite = $Display/Sprite2D

var boss_scene_path = "res://modules/entities/enemies/shades/school_boss/school_boss.tscn"

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_health_component_died() -> void:
	GameManager.hitlag()
	
	if shade_healths_stored.is_empty():
		shade_healths_stored.append(40)
		shade_healths_stored.append(40)
	
	var angle_offset = deg_to_rad(360.0/shade_healths_stored.size())

	for i in range(1, shade_healths_stored.size()+1):
		var enemy_type = enemy_types_stored[i-1]
		
		# Only spawns the boss back in
		if enemy_type == boss_scene_path:
			var enemy_packed = load(enemy_type)
			var enemy = enemy_packed.instantiate()
			
			var hurtbox : HurtBoxComponent2D = enemy.get_node("%HurtBox")
			hurtbox.call_deferred("set_collision_mask_value", 3, false)
			hurtbox.call_deferred("set_collision_mask_value", 13, true)
			
			call_deferred("add_sibling", enemy)
			
			var split_pos = Vector2(cos(angle_offset*i), sin(angle_offset*i))
			enemy.set_deferred("global_position", global_position + split_pos)
			enemy.get_node("%Health").set_deferred("health", shade_healths_stored[i-1])
			
			enemy.get_node("%ShadeFSM").set_deferred("disabled", false)
	
	# Clear the hand array as they no longer exist
	EnemyManager.hand_spawn_counter.clear()
	$AnimationPlayer.play("attack")

func _on_hurt_box_component_2d_hit(_area) -> void:
	$AnimationPlayer.play("hit")

func _on_timer_timeout() -> void:
	EnemyManager.remove_boss_spawned_enemies()
