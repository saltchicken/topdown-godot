class_name InventorySlot
extends PanelContainer

signal change_inventory
@export var type: ItemData.Type

@onready var inventory_item = preload("res://menus/pause_menu/inventory_menu/inventory_item.tscn")

#func init(t: ItemData.Type, cms: Vector2) -> void:
	#type = t
	#custom_minimum_size = cms
	
func add_item(path_to_item):
	var item: InventoryItem
	if path_to_item is String:
		item = inventory_item.instantiate()
		item.init(path_to_item)
	elif path_to_item is InventoryItem:
		item = path_to_item
	else:
		push_error("Error with load_item_into_slot")
		return
	add_child(item)
	
func is_valid_move_slot(item):
	if type == ItemData.Type.MAIN:
		return true
	if type == item.data.type:
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
	#return find_children('*', "ItemData", true, false)[0]
	

func _can_drop_data(_at_position, data):
	if data is InventoryItem:
		if type == ItemData.Type.MAIN:
			if get_child_count() == 0:
				return true
			else:
				if type == data.get_parent().type:
					return true
				return get_child(0).data.type == data.data.type
		else:
			if data.data:
				return data.data.type == type
			else:
				return false
	else:
		return false
	
func _drop_data(_at_position, data):
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		else:
			item.reparent(data.get_parent())
	data.reparent(self)
	change_inventory.emit(data)
