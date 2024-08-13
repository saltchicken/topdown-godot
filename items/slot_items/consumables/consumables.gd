class_name Consumable
extends InventoryItem

func consume_item(item_slot):
	var item = item_slot.get_item()
	if item.stack_count > 1:
		item.stack_count -= 1
	elif item.stack_count == 1:
		item_slot.remove_child(item)
		item.queue_free()
	else:
		push_error("Stack count should not be 0 or lower. Item stack count is ", item.stack_count)
