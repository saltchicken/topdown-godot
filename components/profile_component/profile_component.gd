extends Node

@onready var pause_menu_node = get_node("PauseMenu")
@onready var inventory_menu = get_node("PauseMenu/MenuTabs/Inventory/InventoryMenu")
@onready var spell_menu = get_node("PauseMenu/MenuTabs/Spells/SpellsMenu")
@onready var saved_position = Vector2.ZERO

@onready var level_mapping = PlayerLevelMapping.new()
@onready var experience = 0
@onready var level: int = 0:
	set(value):
		pass
	get:
		@warning_ignore("integer_division")
		return level_mapping.get_level(experience)

@onready var coins = 0

func _ready() -> void:
	add_to_group('PlayerProfilePersist')
	print(inventory_menu)
	#var exp_needed = level_mapping.experience_needed_for_next_level(experience)
	#prints("need for next level:", exp_needed)
	#
	#prints("Level: ", level)
	pass
	
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"node_path" : get_path(),
		"name" : name,
		"coins" : coins,
		"experience" : experience,
		"inventory" : Global.save_slots_to_dict(inventory_menu.item_slots),
		"equipment" : Global.save_slots_to_dict(inventory_menu.equipment_slots),
		"selected_slot" : inventory_menu.selected_slot
	}
	return save_dict
	
func load_inventory(node_data):
	for item in node_data['inventory'].keys():
		inventory_menu.load_item_into_inventory(item, node_data['inventory'][item])
	for item in node_data['equipment'].keys():
		inventory_menu.load_item_into_equipment(item, node_data['equipment'][item])
	inventory_menu.selected_slot = node_data["selected_slot"]
	#update_stats.emit()
	# TODO: Remember to apply equipment modifiers and that this may not be working properly
	#player.purse = node_data["purse"]
