extends Node2D

@onready var buttons = get_node('PanelContainer/HBoxContainer').get_children()
@onready var selected_button: int = 0: set = _set_selected_button

@onready var inventory_menu = get_parent()

func _set_selected_button(new_value):
	if new_value < 0:
		selected_button = 0
	elif new_value >= buttons.size():
		selected_button = buttons.size() - 1
	else:
		selected_button = new_value
	buttons[selected_button].grab_focus()

func _ready() -> void:
	for button in buttons:
		button.pressed.connect(selection_menu_button_pressed.bind(button))

func selection_menu_button_pressed(button):
	match button.name:
		"EquipButton":
			print_debug(button, " matched but not implemented")
		"DropButton":
			print_debug(button, " matched but not implemented")
		"MoveButton":
			inventory_menu.item_to_be_moved = inventory_menu.item_and_equipment_slots[inventory_menu.selected_slot].get_children()[0]
			inventory_menu.close_selection_menu()
			inventory_menu.initial_moved_from_slot = inventory_menu.selected_slot
			inventory_menu.moving_item = true
			inventory_menu.selected_move_slot = inventory_menu.selected_slot
			#inventory_menu.item_and_equipment_slots[inventory_menu.selected_slot].remove_child(inventory_menu.item_to_be_moved)
		_:
			print_debug(button, " not implemented")
