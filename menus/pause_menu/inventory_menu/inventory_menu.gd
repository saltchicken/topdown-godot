extends Node

@onready var player = get_owner().get_owner() # TODO: Better way to reference player for applying equipment modifiers
@onready var pause_menu = get_owner()
@onready var inventory_tab = get_parent()

@onready var style_box = preload('res://menus/pause_menu/item_slot.tres')
@onready var selected_style_box = preload('res://menus/pause_menu/highlighted_item_slot.tres')

@onready var item_slots: Array = get_node('Inventory/VBoxContainer/HBoxContainer').get_children() + get_node('Inventory/VBoxContainer/HBoxContainer2').get_children()
@onready var equipment_slots: Array = get_node('Equipment').get_children()
@onready var item_and_equipment_slots: Array = item_slots + equipment_slots
@onready var inventory_size = item_slots.size()
@onready var inventory_and_equipment_size = item_and_equipment_slots.size()
#
@onready var weapon_slot = get_node('Equipment/WeaponSlot')
@onready var current_weapon: get = _get_current_weapon
#@onready var current_item: get = _get_current_item

@onready var selection_menu = preload("selection_menu/selection_menu.tscn").instantiate()
#
#@onready var purse_label = get_node('PurseLabel')
#
@onready var selected_slot: int = 0: set = _set_selected_slot
@onready var initial_moved_from_slot = null
@onready var moving_item = false
@onready var item_to_be_moved = null
@onready var selected_move_slot: int = -1: set = _set_selected_move_slot # TODO: Maybe use null instead of -1. May be a better way for initial value using selected slot

#signal update_stats

func _ready() -> void:
	add_to_group('Persist')
	#set_purse_text()
	for slot in item_and_equipment_slots:
		slot.change_inventory.connect(inventory_changed.bind(slot))
		
	item_and_equipment_slots[selected_slot].add_theme_stylebox_override('panel', selected_style_box)
	
	selection_menu.visible = false
	add_child(selection_menu)
	
	# THIS IS FOR TESTING A DEFAULT ITEM
	#load_item_into_inventory("res://items/equipment/weapons/iron_sword/iron_sword.tscn", 0)
	#load_item_into_inventory("res://items/equipment/weapons/bow/bow.tscn", 1)
	#load_item_into_inventory("res://items/tools/torch/torch.tscn", 3)
	#load_item_into_inventory("res://resources/items/leather_boots.tres", 5)

func _set_selected_slot(new_value):
	if moving_item == true: # TODO: Needed because setting the selected slot to where it was before moving was bugged.
		selected_slot = new_value
		return
	var previous_slot = selected_slot
	if new_value < 0:
		selected_slot = 0
	elif new_value >= inventory_size and previous_slot < inventory_size:
		selected_slot = 24
	elif new_value >= inventory_and_equipment_size:
		selected_slot = inventory_and_equipment_size - 1
	else:
		selected_slot = new_value
	select_new_slot(previous_slot, selected_slot)
	
func _set_selected_move_slot(new_value):
	if new_value == -1: # TODO: Needed from set selected_move_slot to -1 to reinitialize. Should be a better way. Only a problem in equipment slots
		return 
	var previous_move_slot
	if selected_move_slot != -1:
		previous_move_slot = selected_move_slot
		if new_value < 0:
			selected_move_slot = 0
		elif new_value >= inventory_size and previous_move_slot < inventory_size:
			selected_move_slot = 24
		elif new_value >= inventory_and_equipment_size:
			selected_move_slot = inventory_and_equipment_size - 1
		else:
			selected_move_slot = new_value
	else:
		selected_move_slot = new_value
		previous_move_slot = new_value
	select_new_move_slot(previous_move_slot, selected_move_slot)
	#print(selected_move_slot)
	#print(previous_move_slot)
	
func select_new_slot(previous_slot, new_slot):
	item_and_equipment_slots[previous_slot].add_theme_stylebox_override('panel', style_box)
	item_and_equipment_slots[new_slot].add_theme_stylebox_override('panel', selected_style_box)
	
func select_new_move_slot(previous_move_slot, new_slot):
	# TODO: Add some additional display to show that move selection is on
	if previous_move_slot != new_slot:
		item_and_equipment_slots[previous_move_slot].add_theme_stylebox_override('panel', style_box)
		item_and_equipment_slots[new_slot].add_theme_stylebox_override('panel', selected_style_box)
		item_and_equipment_slots[previous_move_slot].remove_child(item_to_be_moved)
		item_and_equipment_slots[new_slot].add_child(item_to_be_moved)
		

func _get_current_weapon():
	var child_count = weapon_slot.get_child_count()
	if child_count == 0:
		return null
	elif child_count == 1:
		return weapon_slot.get_children()[0].data
	else:
		print('Issue with get_current_weapon. Return null for safety')
		return null
		
#func _get_current_item():
	#if selected_slot >= item_slots.size():
		#return null
	#var child_count = item_slots[selected_slot].get_child_count()
	#if child_count == 0:
		#return null
	#elif child_count == 1:
		#return item_slots[selected_slot].get_children()[0].data
	#else:
		#print('Issue with get_current_weapon. Return null for safety')
		#return null


	
func _process(_delta):
	if pause_menu.visible and inventory_tab.visible:
		if selection_menu.visible == false and moving_item == false:
			input_slot_selection()
		elif selection_menu.visible == false and moving_item == true:
			input_move_item()
		else:
			input_selection_menu()
				
func input_slot_selection():
	if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
		selected_slot -= 1
	if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
		selected_slot += 1
	if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
		if selected_slot <= inventory_size:
			@warning_ignore("integer_division")
			selected_slot -= inventory_size / 2
		else:
			selected_slot -= 2
	if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
		if selected_slot < inventory_size:
			@warning_ignore("integer_division")
			selected_slot += inventory_size / 2
		else:
			selected_slot += 2
			
	if Input.is_action_just_pressed('slot_select_confirm'):
		if item_and_equipment_slots[selected_slot].get_children().size() > 0:
			open_selection_menu(item_and_equipment_slots[selected_slot].get_children()[0].data)
		else:
			print_debug("This slot is empty")
			
func input_move_item():
	if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
		selected_move_slot -= 1
	if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
		selected_move_slot += 1
	if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
		if selected_move_slot <= inventory_size:
			@warning_ignore("integer_division")
			selected_move_slot -= inventory_size / 2
		else:
			selected_move_slot -= 2
	if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
		if selected_move_slot < inventory_size:
			@warning_ignore("integer_division")
			selected_move_slot += inventory_size / 2
		else:
			selected_move_slot += 2
			
	if Input.is_action_just_pressed('slot_select_confirm'):
		# TODO: This needs to also implement stacking
		if !check_if_valid_move_slot(selected_move_slot, item_to_be_moved):
			cancel_item_move()
		elif check_if_item_in_slot(selected_move_slot):
			if item_and_equipment_slots[selected_move_slot].get_children()[0].data.type == item_and_equipment_slots[initial_moved_from_slot].type or item_and_equipment_slots[initial_moved_from_slot].type == ItemData.Type.MAIN:
				var item_to_exchange = item_and_equipment_slots[selected_move_slot].get_children()[0]
				item_and_equipment_slots[selected_move_slot].remove_child(item_to_exchange)
				item_and_equipment_slots[initial_moved_from_slot].add_child(item_to_exchange)
			else:
				cancel_item_move()
		exit_move_mode()
			
	if Input.is_action_just_pressed('slot_select_back'):
		cancel_item_move()
		exit_move_mode()
		
			
	# TODO: Remember to return to the previous selected_slot
	
func cancel_item_move():
	item_and_equipment_slots[selected_move_slot].remove_child(item_to_be_moved)
	item_and_equipment_slots[initial_moved_from_slot].add_child(item_to_be_moved)
	
	

func exit_move_mode():
	selected_slot = selected_move_slot
	selected_move_slot = -1 # TODO: Probably set selected_move_slot to -1 to reinitialize. Should be a better way. Only a problem in equipment slots
	initial_moved_from_slot = null
	moving_item = false
	item_to_be_moved = null
	

func check_if_item_in_slot(slot_index):
	if item_and_equipment_slots[slot_index].get_children().size() > 1:
		return true
	else:
		return false
		
func check_if_valid_move_slot(slot_index, item):
	if item_and_equipment_slots[slot_index].type == ItemData.Type.MAIN:
		return true
	if item_and_equipment_slots[slot_index].type == item.data.type:
		return true
	else:
		return false
	
	
	
func input_selection_menu():
	if Input.is_action_just_pressed("slot_select_confirm"):
		selection_menu.button_container.get_children()[selection_menu.selected_button].pressed.emit()
	if Input.is_action_just_pressed("slot_select_back"):
		close_selection_menu()
	if Input.is_action_just_pressed("up"):
		selection_menu.selected_button -= 1
	if Input.is_action_just_pressed("down"):
		selection_menu.selected_button += 1
	
	
			
				
func open_selection_menu(item):
	selection_menu.set_buttons(item)
	selection_menu.global_position = item_and_equipment_slots[selected_slot].global_position + Vector2(item_and_equipment_slots[selected_slot].size.x, 0.0)
	selection_menu.selected_button = 0
	selection_menu.visible = true
	
func close_selection_menu():
	selection_menu.visible = false
	for button in selection_menu.button_container.get_children():
		selection_menu.button_container.remove_child(button)
		button.queue_free()
#func save_purse():
	#return player.purse
	
func inventory_changed(item, slot):
	print_debug('%s changed. Is there a way to check where it changed from?' % slot) # TODO: Check where slot changed from
	print_debug(item.data)
	print_debug(item.data.name)
	#update_stats.emit()
	
func load_item_into_inventory(path_to_item, slot_index):
	var item := InventoryItem.new()
	item.init(path_to_item)
	#var item_index = _get_first_open_slot()
	#%Inventory.get_child(slot_index).add_child(item)
	#player.profile.inventory[slot_index] = path_to_item
	item_slots[slot_index].add_child(item)
	
func load_item_into_equipment(path_to_item, slot_index):
	var item := InventoryItem.new()
	item.init(path_to_item)
	#var item_index = _get_first_open_slot()
	#%Inventory.get_child(slot_index).add_child(item)
	equipment_slots[slot_index].add_child(item)

func collect_item(item):
	#print(get_first_open_slot())
	load_item_into_inventory(item, get_first_open_slot())
	
func get_first_open_slot():
	for i in item_slots.size():
		if item_slots[i].get_child_count() == 0:
			return i
	return -1 # TODO: Better error handling for when inventory is full
	
func is_in_inventory(): # TODO: Implement 
	pass

#func set_purse_text():
	#purse_label.text = 'Purse: %s' % str(player.purse)
	
#func _on_player_update_purse() -> void:
	#set_purse_text()
