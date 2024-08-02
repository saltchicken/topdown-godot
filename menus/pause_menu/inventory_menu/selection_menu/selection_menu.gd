extends Node2D

@onready var button_container = get_node('PanelContainer/HBoxContainer')
#@onready var buttons = get_node('PanelContainer/HBoxContainer').get_children()
@onready var selected_button: int = 0: set = _set_selected_button

@onready var inventory_menu = get_parent()

func _set_selected_button(new_value):
	var button_container_children = button_container.get_children()
	if new_value < 0:
		selected_button = 0
	elif new_value >= button_container_children.size():
		selected_button = button_container_children.size() - 1
	else:
		selected_button = new_value
	button_container_children[selected_button].grab_focus()

#func _ready() -> void:
	#for button in buttons:
		#button.pressed.connect(selection_menu_button_pressed.bind(button))
		
func set_buttons(item):
	for action in item.menu_actions:
		var button = Button.new()
		button.text = ItemData.MenuActions.keys()[action]
		button_container.add_child(button)
		button.pressed.connect(selection_menu_button_pressed.bind(button))

func selection_menu_button_pressed(button):
	match button.text:
		"EQUIP":
			print_debug(button, " matched but not implemented")
		"DROP":
			print_debug(button, " matched but not implemented")
		"MOVE":
			inventory_menu.item_to_be_moved = inventory_menu.item_and_equipment_slots[inventory_menu.selected_slot].get_children()[0]
			inventory_menu.close_selection_menu()
			inventory_menu.initial_moved_from_slot = inventory_menu.selected_slot
			inventory_menu.moving_item = true
			inventory_menu.selected_move_slot = inventory_menu.selected_slot
			#inventory_menu.item_and_equipment_slots[inventory_menu.selected_slot].remove_child(inventory_menu.item_to_be_moved)
		_:
			print_debug(button.text, " not implemented")
