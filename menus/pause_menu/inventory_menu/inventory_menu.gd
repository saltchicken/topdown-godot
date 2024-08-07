extends Node

const ROW = 0
const COLUMN = 1

@onready var player = get_owner().get_owner() # TODO: Better way to reference player for applying equipment modifiers
@onready var pause_menu = get_owner()
@onready var inventory_tab = get_parent()
@onready var toolbelt = get_owner().get_owner().get_node("ProfileComponent/Hud/ToolBelt")
@onready var selection_menu = Global.get_node("Text/SelectionMenu")

@onready var style_box = preload('res://menus/pause_menu/item_slot.tres')
@onready var selected_style_box = preload('res://menus/pause_menu/highlighted_item_slot.tres')

@onready var inventory_rows = [4,5,6] # TODO: More sophisticated way of determining which rows in slots can hold inventory.

var move_input_enabled = false
var input_enabled = false

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
func _set_selected_slot(vector):
	if vector[ROW] < 0: vector[ROW] = 0
	if vector[COLUMN] < 0: vector[COLUMN] = 0
	if vector[ROW] >= slots.size(): vector[ROW] = slots.size() - 1
	if vector[COLUMN] >= slots[vector[ROW]].size(): vector[COLUMN] = slots[vector[ROW]].size() - 1
	
	# TODO When slot selection is on the right hand side then even the selection out
	
	if moving_item == false:	
		select_new_slot(selected_slot, vector) # selected_slot is the previous slot
	else:
		select_new_move_slot(selected_slot, vector)
	selected_slot = vector
	
@onready var initial_moved_from_slot = null
@onready var moving_item = false
@onready var item_to_be_moved = null

func _ready() -> void:
	add_to_group('Persist')
	#set_purse_text()
	await toolbelt.ready
	_create_slot_array()
	for row in slots:
		for slot in row:
			slot.change_inventory.connect(inventory_changed.bind(slot))
		
	select_new_slot(selected_slot, selected_slot)
	
	#selection_menu.visible = false
	#add_child(selection_menu)
	
	selection_menu.action.connect(on_selection_menu_action)
	
	# THIS IS FOR TESTING A DEFAULT ITEM
	#load_item_into_slot("res://items/equipment/weapons/iron_sword/iron_sword.tscn", [4, 1])
	#load_item_into_slot("res://items/equipment/weapons/bow/bow.tscn", [4, 2])
	#load_item_into_slot("res://items/tools/torch/torch.tscn", [4,3])
	#load_item_into_slot("res://items/consumables/potions/health_potion/health_potion.tscn", [4, 5])
	
func _process(_delta):
	if pause_menu.visible and inventory_tab.visible and selection_menu.visible == false:
		if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'): selected_slot[COLUMN] -= 1
		if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'): selected_slot[COLUMN] += 1
		if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'): selected_slot[ROW] -= 1
		if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'): selected_slot[ROW] += 1
		if moving_item == false:
			if Input.is_action_just_released("slot_select_confirm") or Input.is_action_just_released("inventory"): input_enabled = true
			if input_enabled:
				if Input.is_action_just_pressed('slot_select_confirm'):
					var selected_slot = get_slot(selected_slot)
					if selected_slot.get_children().size() > 0:
						open_selection_menu(selected_slot.get_children()[0].data)
					else:
						print_debug("This slot is empty")
					input_enabled = false
		else:
			if Input.is_action_just_released("slot_select_confirm"): move_input_enabled = true
			if move_input_enabled:
				if Input.is_action_just_pressed('slot_select_confirm'):
					# TODO: This needs to also implement stacking
					var selected_slot = get_slot(selected_slot)
					if !selected_slot.is_valid_move_slot(item_to_be_moved):
						cancel_item_move()
					elif selected_slot.is_item_in_slot():
						var initial_moved_from_slot = get_slot(initial_moved_from_slot)
						if selected_slot.get_children()[0].data.type == initial_moved_from_slot.type or initial_moved_from_slot.type == ItemData.Type.MAIN:
							var item_to_exchange = selected_slot.get_children()[0]
							selected_slot.remove_child(item_to_exchange)
							initial_moved_from_slot.add_child(item_to_exchange)
						else:
							cancel_item_move()
					exit_move_mode()
					move_input_enabled = false
						
				if Input.is_action_just_pressed('slot_select_back'):
					cancel_item_move()
					exit_move_mode()
					move_input_enabled = false
				
			# TODO: Remember to return to the previous selected_slot	

func on_selection_menu_action(action):
	match action:
		"Use":
			close_selection_menu()
			var item_slot = get_slot(selected_slot)
			item_slot.get_children()[0].data.get_node("Use").use(self, item_slot)
			input_enabled = false
		"Move":
			close_selection_menu()
			item_to_be_moved = get_slot(selected_slot).get_children()[0]
			initial_moved_from_slot = selected_slot
			moving_item = true
		"Close":
			close_selection_menu()
		"Drop":
			drop_item()
		_:
			push_error(action, " not implemented yet")
	
	
func select_new_slot(previous_vector, vector):
	get_slot(previous_vector).add_theme_stylebox_override('panel', style_box)
	get_slot(vector).add_theme_stylebox_override('panel', selected_style_box)
	
func select_new_move_slot(previous_move_slot, new_slot):
	# TODO: Add some additional display to show that move selection is on
	if previous_move_slot != new_slot:
		get_slot(previous_move_slot).add_theme_stylebox_override('panel', style_box)
		get_slot(new_slot).add_theme_stylebox_override('panel', selected_style_box)
		get_slot(previous_move_slot).remove_child(item_to_be_moved)
		get_slot(new_slot).add_child(item_to_be_moved)
	
func cancel_item_move():
	get_slot(selected_slot).remove_child(item_to_be_moved)
	get_slot(initial_moved_from_slot).add_child(item_to_be_moved)
	
func exit_move_mode():
	initial_moved_from_slot = null
	moving_item = false
	item_to_be_moved = null
	
func open_selection_menu(item):
	selection_menu.set_buttons(item)
	var selected_slot = get_slot(selected_slot)
	selection_menu.get_node("PanelContainer").global_position = selected_slot.global_position + Vector2(selected_slot.size.x, 0.0)
	selection_menu.selected_button = 0
	selection_menu.visible = true
	
func close_selection_menu():
	input_enabled = true
	selection_menu.visible = false
	for button in selection_menu.button_container.get_children():
		selection_menu.button_container.remove_child(button)
		button.queue_free()
	
func inventory_changed(item, slot):
	print_debug('%s changed. Is there a way to check where it changed from?' % slot) # TODO: Check where slot changed from
	print_debug(item.data)
	print_debug(item.data.name)
	#update_stats.emit()
	
func collect_item(item):
	var first_open_slot = get_first_open_slot()
	if first_open_slot != null:
		get_slot(first_open_slot).add_item(item)
	else:
		print_debug("There is no available slot. Implement logic here")
		
func get_slot(slot_vector):
	return slots[slot_vector[ROW]][slot_vector[COLUMN]]
	
func get_first_open_slot():
	for row_index in inventory_rows:
		for slot_index in slots[row_index].size():
			if slots[row_index][slot_index].get_child_count() == 0:
				return [row_index, slot_index]
	return null

# NOTE: Has not been tested
func is_in_inventory(item): # TODO: Implement
	var existing_slots = []
	for row_index in inventory_rows:
		for slot_index in slots[row_index].size():
			if slots[row_index][slot_index].get_child_count() > 0:
				if item == slots[row_index][slot_index].data:
					existing_slots.append([row_index, slot_index])
	return existing_slots
	
func drop_item():
	var selected_slot = get_slot(selected_slot)
	var item = selected_slot.get_children()[0]
	selected_slot.remove_child(item)
	#var item = item_to_drop.data
	#item_to_drop.queue_free()
	item.global_position = player.global_position - Vector2(0.0, -100.0)
	item.size = Vector2(32.0, 32.0)
	var collectable_component = preload("res://components/collectable_component/collectable_component.tscn").instantiate()
	collectable_component.position = item.size / 2
	item.add_child(collectable_component)
	owner.get_node('/root/Gameplay').current_level.add_child(item)

#func set_purse_text():
	#purse_label.text = 'Purse: %s' % str(player.purse)
	
#func _on_player_update_purse() -> void:
	#set_purse_text()
