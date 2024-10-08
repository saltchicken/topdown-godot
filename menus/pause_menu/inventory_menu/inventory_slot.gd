class_name InventorySlot
extends PanelContainer

signal change_inventory
@export var type: InventoryItem.Type

#func init(t: InventoryItem.Type, cms: Vector2) -> void:
	#type = t
	#custom_minimum_size = cms
	
func add_item(path_to_item):
	var item: InventoryItem
	if path_to_item is String:
		item = load(path_to_item).instantiate()
	elif path_to_item is InventoryItem:
		item = path_to_item
	else:
		push_error("Error with load_item_into_slot")
		return
	add_child(item)
	
func is_valid_move_slot(item):
	if type == InventoryItem.Type.MAIN:
		return true
	if type == item.type:
		return true
	else:
		return false
		
func is_item_in_slot():
	for child in get_children():
		if child is TextureRect:
			return true
	return false
	
func is_item_in_slot_moving():
	var count = 0
	for child in get_children():
		if child is TextureRect:
			count += 1
	if count > 1:
		return true
	else:
		return false
		
func get_item():
	for child in get_children():
		if child is TextureRect:
			return child
	#return find_children('*', "InventoryItem", true, false)[0]
	
func combine_stack(item_to_be_moved):
	get_item().stack_count += item_to_be_moved.stack_count
	item_to_be_moved.queue_free()
	

func _can_drop_data(_at_position, data):
	if data is InventoryItem:
		if type == InventoryItem.Type.MAIN:
			if get_child_count() == 0:
				return true
			else:
				if type == data.get_parent().type:
					return true
				return get_child(0).type == data.type
		else:
			if data:
				return data.type == type
			else:
				return false
	else:
		return false
	
func _drop_data(_at_position, item_to_be_moved):
	if get_child_count() > 0:
		var item_in_selected_slot := get_child(0)
		#print("item_in_selected_slot ", item_in_selected_slot, "   item_to_be_moved ", item_to_be_moved)
		if item_in_selected_slot == item_to_be_moved:
			return
		if item_in_selected_slot.item_name == item_to_be_moved.item_name and item_in_selected_slot.stackable:
			combine_stack(item_to_be_moved)
		else:
			item_in_selected_slot.reparent(item_to_be_moved.get_parent())
	item_to_be_moved.reparent(self)
	#change_inventory.emit(data)
