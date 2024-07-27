extends Node2D

@onready var equip_button = get_node('PanelContainer/HBoxContainer/EquipButton')
@onready var drop_button = get_node('PanelContainer/HBoxContainer/DropButton')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	equip_button.pressed.connect(on_equip_pressed)
	drop_button.pressed.connect(on_drop_pressed)
	
func on_equip_pressed():
	print_debug("Need to implement equip pressed")
	
func on_drop_pressed():
	print_debug("Need to implement drop pressed")
