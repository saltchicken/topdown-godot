extends Node

const ROW = 0
const COLUMN = 1

@onready var player = get_owner().get_owner() # TODO: Better way to reference player for applying equipment modifiers
@onready var pause_menu = get_owner()
@onready var inventory_tab = get_parent()
@onready var toolbelt = get_owner().get_owner().get_node("ProfileComponent/Hud/ToolBelt")
@onready var selection_menu = preload("selection_menu/selection_menu.tscn").instantiate()

@onready var style_box = preload('res://menus/pause_menu/item_slot.tres')
@onready var selected_style_box = preload('res://menus/pause_menu/highlighted_item_slot.tres')

@onready var slots = []
func _create_slot_array():
	for row in get_node("Equipment").get_children():
		var slot_row = []
		for slot in row.get_children():
			slot_row.append(slot)
		slots.append(slot_row)
	for row in get_node("Inventory").get_children():
		var slot_row = []
		for slot in row.get_children():
			slot_row.append(slot)
		slots.append(slot_row)
	var slot_row = []
	for slot in toolbelt.get_children():
		slot_row.append(slot)
	slots.append(slot_row)
		
@onready var weapon_slot = get_node('Equipment/Weapons/PrimaryWeaponSlot')
@onready var current_weapon: get = _get_current_weapon
func _get_current_weapon():
	var child_count = weapon_slot.get_child_count()
	if child_count == 0:
		return null
	elif child_count == 1:
		return weapon_slot.get_children()[0].data
	else:
		print('Issue with get_current_weapon. Return null for safety')
		return null

#@onready var purse_label = get_node('PurseLabel')
#
@onready var selected_slot: Vector2i = Vector2i(4,0): set = _set_selected_slot
@onready var initial_moved_from_slot = null
@onready var moving_item = false
@onready var item_to_be_moved = null
#@onready var selected_move_slot: Vector2i: set = _set_selected_move_slot
#@onready var selected_move_slot: Vector2i

#signal update_stats

func _ready() -> void:
	add_to_group('Persist')
	#set_purse_text()
	await toolbelt.ready
	_create_slot_array()
	for row in slots:
		for slot in row:
			slot.change_inventory.connect(inventory_changed.bind(slot))
		
	select_new_slot(selected_slot, selected_slot)
	#item_and_equipment_slots[selected_slot].add_theme_stylebox_override('panel', selected_style_box)
	
	selection_menu.visible = false
	add_child(selection_menu)
	
	# THIS IS FOR TESTING A DEFAULT ITEM
	#load_item_into_slot("res://items/equipment/weapons/iron_sword/iron_sword.tscn", [4, 1])
	#load_item_into_slot("res://items/equipment/weapons/bow/bow.tscn", [4, 2])
	#load_item_into_slot("res://items/tools/torch/torch.tscn", [4,3])
	#load_item_into_inventory("res://resources/items/leather_boots.tres", 5)

func _set_selected_slot(vector):
	if vector[ROW] < 0: vector[ROW] = 0
	if vector[COLUMN] < 0: vector[COLUMN] = 0
	if vector[ROW] >= slots.size(): vector[ROW] = slots.size() - 1
	if vector[COLUMN] >= slots[vector[ROW]].size(): vector[COLUMN] = slots[vector[ROW]].size() - 1
	
	
	# TODO When slot selection is on the right hand side then even the selection out
	
	#if vector[ROW] != selected_slot[ROW]:
		#if selected_slot[COLUMN] > slots[selected_slot[ROW]].size() / 2:
			#vector[COLUMN] = round(slots[vector[ROW]].size() / 2)
			
	
	#if vector[COLUMN] >= slots[vector[ROW]].size():
		#vector[COLUMN] = slots[vector[ROW]].size()
	if moving_item == false:	
		select_new_slot(selected_slot, vector) # selected_slot is the previous slot
	else:
		select_new_move_slot(selected_slot, vector)
	selected_slot = vector
	#selected_move_slot = vector # TODO: Can probably delete this and selected_move_slot
	

func select_new_slot(previous_vector, vector):
	slots[previous_vector[ROW]][previous_vector[COLUMN]].add_theme_stylebox_override('panel', style_box)
	slots[vector[ROW]][vector[COLUMN]].add_theme_stylebox_override('panel', selected_style_box)
		
	
	#if moving_item == true: # TODO: Needed because setting the selected slot to where it was before moving was bugged.
		#selected_slot = new_value
		#return

	
#func _set_selected_move_slot(new_value):
	#if new_value == -1: # TODO: Needed from set selected_move_slot to -1 to reinitialize. Should be a better way. Only a problem in equipment slots
		#return 
	#var previous_move_slot
	#if selected_move_slot != -1:
		#previous_move_slot = selected_move_slot
		#if new_value < 0:
			#selected_move_slot = 0
		#elif new_value >= inventory_size and previous_move_slot < inventory_size:
			#selected_move_slot = 24
		#elif new_value >= inventory_and_equipment_size:
			#selected_move_slot = inventory_and_equipment_size - 1
		#else:
			#selected_move_slot = new_value
	#else:
		#selected_move_slot = new_value
		#previous_move_slot = new_value
	#select_new_move_slot(previous_move_slot, selected_move_slot)
	##print(selected_move_slot)
	##print(previous_move_slot)
	

	
func select_new_move_slot(previous_move_slot, new_slot):
	# TODO: Add some additional display to show that move selection is on
	if previous_move_slot != new_slot:
		slots[previous_move_slot[ROW]][previous_move_slot[COLUMN]].add_theme_stylebox_override('panel', style_box)
		slots[new_slot[ROW]][new_slot[COLUMN]].add_theme_stylebox_override('panel', selected_style_box)
		slots[previous_move_slot[ROW]][previous_move_slot[COLUMN]].remove_child(item_to_be_moved)
		slots[new_slot[ROW]][new_slot[COLUMN]].add_child(item_to_be_moved)
		


		
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
		selected_slot[COLUMN] -= 1
	if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
		selected_slot[COLUMN] += 1
	if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
		selected_slot[ROW] -= 1
	if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
		selected_slot[ROW] += 1
			
	if Input.is_action_just_pressed('slot_select_confirm'):
		if slots[selected_slot[ROW]][selected_slot[COLUMN]].get_children().size() > 0:
			open_selection_menu(slots[selected_slot[ROW]][selected_slot[COLUMN]].get_children()[0].data)
		else:
			print_debug("This slot is empty")
			
func input_move_item():
	if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
		selected_slot[COLUMN] -= 1
	if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
		selected_slot[COLUMN] += 1
	if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
		selected_slot[ROW] -= 1
	if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
		selected_slot[ROW] += 1
			
	if Input.is_action_just_pressed('slot_select_confirm'):
		# TODO: This needs to also implement stacking
		if !check_if_valid_move_slot(selected_slot, item_to_be_moved):
			cancel_item_move()
		elif check_if_item_in_slot(selected_slot):
			if slots[selected_slot[ROW]][selected_slot[COLUMN]].get_children()[0].data.type == slots[initial_moved_from_slot[ROW]][initial_moved_from_slot[COLUMN]].type or slots[initial_moved_from_slot[ROW]][initial_moved_from_slot[COLUMN]].type == ItemData.Type.MAIN:
				var item_to_exchange = slots[selected_slot[ROW]][selected_slot[COLUMN]].get_children()[0]
				slots[selected_slot[ROW]][selected_slot[COLUMN]].remove_child(item_to_exchange)
				slots[initial_moved_from_slot[ROW]][initial_moved_from_slot[COLUMN]].add_child(item_to_exchange)
			else:
				cancel_item_move()
		exit_move_mode()
			
	if Input.is_action_just_pressed('slot_select_back'):
		print('cancel')
		cancel_item_move()
		exit_move_mode()
		
			
	# TODO: Remember to return to the previous selected_slot
	
func cancel_item_move():
	slots[selected_slot[ROW]][selected_slot[COLUMN]].remove_child(item_to_be_moved)
	slots[initial_moved_from_slot[ROW]][initial_moved_from_slot[COLUMN]].add_child(item_to_be_moved)
	
	

func exit_move_mode():
	#selected_slot = selected_move_slot
	#selected_move_slot = -1 # TODO: Probably set selected_move_slot to -1 to reinitialize. Should be a better way. Only a problem in equipment slots
	initial_moved_from_slot = null
	moving_item = false
	item_to_be_moved = null
	

func check_if_item_in_slot(slot_index):
	if slots[slot_index[ROW]][slot_index[COLUMN]].get_children().size() > 1:
		return true
	else:
		return false
		
func check_if_valid_move_slot(slot_vector, item):
	if slots[slot_vector[ROW]][slot_vector[COLUMN]].type == ItemData.Type.MAIN:
		return true
	if slots[slot_vector[ROW]][slot_vector[COLUMN]].type == item.data.type:
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
	selection_menu.global_position = slots[selected_slot[ROW]][selected_slot[COLUMN]].global_position + Vector2(slots[selected_slot[ROW]][selected_slot[COLUMN]].size.x, 0.0)
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
	
#func load_item_into_inventory(path_to_item, slot_index):
	#var item := InventoryItem.new()
	#item.init(path_to_item)
	##var item_index = _get_first_open_slot()
	##%Inventory.get_child(slot_index).add_child(item)
	##player.profile.inventory[slot_index] = path_to_item
	#item_slots[slot_index].add_child(item)
	
func load_item_into_slot(path_to_item, slot_vector):
	var item := InventoryItem.new()
	item.init(path_to_item)
	print("loading into ")
	print(slot_vector)
	slots[slot_vector[ROW]][slot_vector[COLUMN]].add_child(item)
	
#func load_item_into_equipment(path_to_item, slot_index):
	#var item := InventoryItem.new()
	#item.init(path_to_item)
	##var item_index = _get_first_open_slot()
	##%Inventory.get_child(slot_index).add_child(item)
	#equipment_slots[slot_index].add_child(item)

#func collect_item(item):
	##print(get_first_open_slot())
	#load_item_into_inventory(item, get_first_open_slot())
	
#func get_first_open_slot():
	#for i in item_slots.size():
		#if item_slots[i].get_child_count() == 0:
			#return i
	#return -1 # TODO: Better error handling for when inventory is full
	
func is_in_inventory(): # TODO: Implement 
	pass

#func set_purse_text():
	#purse_label.text = 'Purse: %s' % str(player.purse)
	
#func _on_player_update_purse() -> void:
	#set_purse_text()
