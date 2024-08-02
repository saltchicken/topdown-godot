extends Node

@onready var player = get_owner().get_owner() # TODO: Better way to reference player for applying equipment modifiers
@onready var pause_menu = get_owner()
@onready var spells_tab = get_parent()

@onready var spell_slots: Array = get_node('Spells/VBoxContainer/HBoxContainer').get_children()
#@onready var current_spells_slots: Array = get_node('CurrentSpells').get_children()

@onready var style_box = preload('res://menus/pause_menu/item_slot.tres')
@onready var selected_style_box = preload('res://menus/pause_menu/highlighted_item_slot.tres')
@onready var selected_slot: int = 0: set = _set_selected_slot

@onready var current_spell: get = _get_current_spell

#signal update_stats

func _get_current_spell():
	var child_count = spell_slots[selected_slot].get_child_count()
	if child_count == 0:
		return null
	elif child_count == 1:
		return spell_slots[selected_slot].get_children()[0].data
	else:
		print('Issue with get_current_spell. Return null for safety')
		return null

func _set_selected_slot(new_value):
	var previous_slot = selected_slot
	if new_value < 0:
		selected_slot = 0
	elif new_value >= spell_slots.size():
		selected_slot = spell_slots.size() - 1
	else:
		selected_slot = new_value
	select_new_slot(previous_slot, selected_slot)
	
func select_new_slot(previous_slot, new_slot):
	spell_slots[previous_slot].add_theme_stylebox_override('panel', style_box)
	spell_slots[new_slot].add_theme_stylebox_override('panel', selected_style_box)



func _ready() -> void:
	add_to_group('Persist')
	for slot in spell_slots:
		slot.change_spell.connect(spell_changed.bind(slot))
		
	spell_slots[selected_slot].add_theme_stylebox_override('panel', selected_style_box)
	
	#for slot in current_spells_slots:
		#slot.change_spell.connect(spell_changed.bind(slot))
		
	# FOR TESTING
	load_item_into_spell("res://spells/whirlwind/whirlwind.tscn", 0)
	load_item_into_spell("res://spells/fireball/fireball.tscn", 1)
	load_item_into_spell("res://spells/lightning_bolt/lightning_bolt.tscn", 4)
	
	
func _process(_delta):
	if pause_menu.visible and spells_tab.visible:
		if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
			selected_slot -= 1
		if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
			selected_slot += 1
		#if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
			#if selected_slot <= inventory_size:
				#@warning_ignore("integer_division")
				#selected_slot -= inventory_size / 2
			#else:
				#selected_slot -= 2
		#if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
			#if selected_slot < inventory_size:
				#@warning_ignore("integer_division")
				#selected_slot += inventory_size / 2
			#else:
				#selected_slot += 2
	
func load_item_into_spell(path_to_item, slot_index):
	var spell := SpellItem.new()
	spell.init(path_to_item)
	#var item_index = _get_first_open_slot()
	#%Inventory.get_child(slot_index).add_child(item)
	spell_slots[slot_index].add_child(spell)
	
#func load_item_into_current_spells(path_to_item, slot_index):
	#var spell := SpellItem.new()
	#spell.init(load(path_to_item))
	##var item_index = _get_first_open_slot()
	##%Inventory.get_child(slot_index).add_child(item)
	#current_spells_slots[slot_index].add_child(spell)
	
func spell_changed(slot):
	print('%s changed. Is there a way to check where it changed from?' % slot) # TODO: Check where slot changed from
	#if slot == current_spell:
		#print('Current Spell changed. Currently no logic is being applied')
	#if current_spell.get_child_count() > 0:
		#player.current_spell = load(slot.get_children()[0].data.scene)
	#else:
		#player.current_spell = null
		
func save():
	var save_dict = {
		"node_name" : self.name,
		"spell_slots" : SceneManager.save_slots_to_dict(spell_slots),
		#"current_spells_slots" : SceneManager.save_slots_to_dict(current_spells_slots)
	}
	return save_dict
	
func load(node_data):
	for item in node_data['spell_slots'].keys():
		load_item_into_spell(item, node_data['spell_slots'][item])
	#for item in node_data['current_spells_slots'].keys():
		#load_item_into_current_spells(item, node_data['current_spells_slots'][item])
	#player.get_node('SpellSelectionMenu').spell_menu_spell_changed(null) #TODO: Shouldn't be passing null here.
	
#func save_spells():
	#var spell_dict = {}
	#for i in range(spell_slots.size()):
		#var slot = spell_slots[i]
		#if slot.get_child_count() > 0:
			#var spell = slot.get_child(0)
			#if spell:
				#spell_dict[spell.data.get_path()] = i
	#return spell_dict
	#
#func save_current_spells():
	#var current_spells_dict = {}
	#for i in range(current_spells_slots.size()):
		#var slot = current_spells_slots[i]
		#if slot.get_child_count() > 0:
			#var spell = slot.get_child(0)
			#if spell:
				#current_spells_dict[spell.data.get_path()] = i
	#return current_spells_dict
	
	#func save_inventory():
	#var inventory_dict = {}
	#for i in range(item_slots.size()):
		#var slot = item_slots[i]
		#if slot.get_child_count() > 0:
			#var item = slot.get_child(0)
			#if item:
				#inventory_dict[item.data.get_path()] = i
	#return inventory_dict
	#
#func save_equipment():
	#var equipment_dict = {}
	#for i in range(equipment_slots.size()):
		#var slot = equipment_slots[i]
		#if slot.get_child_count() > 0:
			#var item = slot.get_child(0)
			#if item:
				#equipment_dict[item.data.get_path()] = i
	#return equipment_dict
	
