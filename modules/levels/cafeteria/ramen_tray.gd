extends TetherableBody

@export var spawns_wanderer : bool
@export var item_stack : ItemType

@onready var dispenser_node = $"../../.."

var great_grandparent

func _ready():
	var end_pos = global_position + Vector2(0, 10)
	var tween = create_tween()
	tween.tween_property(self, "global_position", end_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
	if spawns_wanderer:
		call_deferred("spawn_wanderer")
	else:
		$TetherableArea2D.monitorable = true
		$Item.monitoring = true
		var item_item = ItemStack.new(item_stack, 1, null)
		$Item.item_stack = item_item

func spawn_wanderer():
	var wanderer = load("res://modules/levels/cafeteria/wanderer.tscn")
	var wanderer_instance : CharacterBody2D = wanderer.instantiate()
	get_tree().current_scene.add_child(wanderer_instance)
	wanderer_instance.pick_up.connect(pick_up_tray)
	
	# set their location to a bit downwards, and their end location as our end_location
	wanderer_instance.global_position = global_position + Vector2(0, randi_range(36, 48))
	wanderer_instance.set_path(global_position + Vector2(0, 30), 1.0)
	
func spawn_ramen_seeker():
	var seeker = load("res://modules/levels/cafeteria/shade_varieties/ramen_shade.tscn")
	var seeker_instance : CharacterBody2D = seeker.instantiate()
	get_tree().current_scene.add_child(seeker_instance)
	
	# set their location to a bit downwards, and their end location as our end_location
	seeker_instance.global_position = get_parent().get_parent().global_position + Vector2(randi_range(-96, 96), 160)
	seeker_instance.get_node("ShadeFSM").change_state("SeekingRamen")
	
func pick_up_tray(body):
	# ramen's been taken by someone else
	remove_from_group("edible_ramen")
	
	# keeps movement tracking to each other
	reparent(body)
	position += Vector2(0,16)

	#stops shining shader
	$CanvasGroup/Sprite2D.call_deferred("reparent", self)
	$Item.set_deferred("monitoring", false)

func _on_item_body_entered(body: Node2D) -> void:
	# stops being tetherable
	$TetherableArea2D.set_deferred("monitorable", false)
		
	if body.is_in_group("player"):
		$Item.set_deferred("monitoring", false)
		var deinv = GameManager.inventory_node.inventory
		$Item.try_pickup(deinv)
		dispenser_node.player_got_ramen()
		#deinv.save_state("player_inventory")
		queue_free()
		
	
	elif body.is_in_group("enemy"):
		player.get_node("PlayerFSM").change_state("Recall")
		$Item.set_deferred("monitoring", false)
		remove_from_group("edible_ramen")
		
		#reparent self to shade to track with it
		call_deferred("reparent",body)
		body.get_node("ShadeFSM").change_state("FoundRamen")
		global_position = body.global_position
		
		#stops shining shader
		$CanvasGroup/Sprite2D.call_deferred("reparent", self)
		
		dispenser_node.shade_got_ramen(body)

func pull():
	$Item.set_collision_mask_value(4, false)
	super.pull()
	
func fling():
	$Item.set_collision_mask_value(4, false)
	super.fling()
