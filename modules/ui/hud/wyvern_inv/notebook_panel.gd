extends Panel

signal check_hook
func _on_equip_item_stack_added(_item_stack: ItemStack) -> void:
	check_hook.emit()
