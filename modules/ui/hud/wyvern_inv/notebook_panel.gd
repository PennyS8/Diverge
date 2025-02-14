extends Panel

signal check_hook
func _on_equip_item_stack_added(item_stack: ItemStack) -> void:
	check_hook.emit()
