extends Node2D

#@onready var equip_button = get_node('PanelContainer/HBoxContainer/EquipButton')
#@onready var drop_button = get_node('PanelContainer/HBoxContainer/DropButton')

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in buttons:
		button.pressed.connect(selection_menu_button_pressed.bind(button))
	
	#equip_button.pressed.connect(on_equip_pressed)
	#drop_button.pressed.connect(on_drop_pressed)
	
#func on_equip_pressed():
	#print_debug("Need to implement equip pressed")
	#
#func on_drop_pressed():
	#print_debug("Need to implement drop pressed")

func selection_menu_button_pressed(button):
	print_debug(button, " not implemented")
