extends Node2D

@onready var buttons = get_node('PanelContainer/HBoxContainer').get_children()
@onready var selected_button: int = 0: set = _set_selected_button

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
			print_debug(button, " matched but not implemented")
		_:
			print_debug(button, " not implemented")
