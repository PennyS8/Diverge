class_name NatesGroundItem extends Node2D

## The item to be passed to the GroundItemStackView2D
@export var ground_item : ItemType
@export var num_item : int = 1
@onready var item_node = $Item

func _ready():
	var stack = ItemStack.new(ground_item, num_item)
	item_node.item_stack = stack

func _on_item_body_entered(_body):
	# adds to juni's main inventory. if want to change this let me know and we'll figure it out
	var deinv = GameManager.inventory_node.inventory
	$Item.try_pickup(deinv)
