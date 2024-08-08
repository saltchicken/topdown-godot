extends Node2D

const ROW = 0
const COLUMN = 1

@onready var button_container = get_node('PanelContainer/HBoxContainer')
#@onready var buttons = get_node('PanelContainer/HBoxContainer').get_children()
@onready var selected_button: int = 0: set = _set_selected_button

@onready var inventory_menu = get_parent()

@onready var input_enabled = false

signal use
signal move
signal close

func _set_selected_button(new_value):
	var button_container_children = button_container.get_children()
	if new_value < 0:
		selected_button = 0
	elif new_value >= button_container_children.size():
		selected_button = button_container_children.size() - 1
	else:
		selected_button = new_value
	button_container_children[selected_button].grab_focus()
	
func _process(_delta):
	if visible:
		if Input.is_action_just_released('slot_select_confirm'):
			input_enabled = true
		if input_enabled:
			if Input.is_action_just_pressed("slot_select_confirm"):
				button_container.get_children()[selected_button].pressed.emit()
				input_enabled = false
			if Input.is_action_just_pressed("slot_select_back"):
				close.emit()
				input_enabled = false
			if Input.is_action_just_pressed("up"):
				selected_button -= 1
			if Input.is_action_just_pressed("down"):
				selected_button += 1
	#else:
		#input_enabled = false

#func _ready() -> void:
	#for button in buttons:
		#button.pressed.connect(selection_menu_button_pressed.bind(button))

func _create_button(text):
	var button = Button.new()
	button.text = text
	button_container.add_child(button)
	button.pressed.connect(selection_menu_button_pressed.bind(button))
	
		
func set_buttons(item):
	if item.get_node_or_null("Use"):
		_create_button("Use")
	_create_button("Move")
	_create_button("Drop")

func selection_menu_button_pressed(button):
	match button.text:
		"Examine":
			print_debug(button, " matched but not implemented")
		"Use":
			use.emit()
		"Equip":
			print_debug(button, " matched but not implemented")
		"Drop":
			inventory_menu.drop_item()
		"Move":
			move.emit()
		_:
			print_debug(button.text, " not implemented")
