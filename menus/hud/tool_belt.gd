extends HBoxContainer

@onready var selected_slot: int = 0: set = _set_selected_slot
@onready var toolbelt_slots = get_children()

@onready var current_item: get = _get_current_item

@onready var style_box = preload('res://menus/pause_menu/item_slot.tres')
@onready var selected_style_box = preload('res://menus/pause_menu/highlighted_item_slot.tres')

@onready var inventory_item = preload("res://items/slot_items/inventory_item.tscn")

func _set_selected_slot(new_value):
	#if moving_item == true: # TODO: Needed because setting the selected slot to where it was before moving was bugged.
		#selected_slot = new_value
		#return
	var toolbelt_size = toolbelt_slots.size()
	var previous_slot = selected_slot
	if new_value < 0:
		selected_slot = 0
	elif new_value >= toolbelt_size:
		selected_slot = toolbelt_size - 1
	else:
		selected_slot = new_value
	select_new_slot(previous_slot, selected_slot)
# Called when the node enters the scene tree for the first time.

func _get_current_item():
	if selected_slot >= toolbelt_slots.size():
		return null
	var child_count = toolbelt_slots[selected_slot].get_child_count()
	if child_count == 0:
		return null
	elif child_count == 1:
		return toolbelt_slots[selected_slot].get_item()
	else:
		print('Issue with get_current_weapon. Return null for safety')
		return null

func select_new_slot(previous_slot, new_slot):
	toolbelt_slots[previous_slot].add_theme_stylebox_override('panel', style_box)
	toolbelt_slots[new_slot].add_theme_stylebox_override('panel', selected_style_box)
	
func load_item_into_toolbelt(path_to_item, slot_index):
	var item := inventory_item.instantiate()
	item.init(path_to_item)
	toolbelt_slots[slot_index].add_child(item)
	
func _ready() -> void:
	toolbelt_slots[selected_slot].add_theme_stylebox_override('panel', selected_style_box)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toolbelt_right"):
		selected_slot += 1
	if Input.is_action_just_pressed("toolbelt_left"):
		selected_slot -= 1
	if Input.is_action_just_pressed("key_1"):
		selected_slot = 0
	if Input.is_action_just_pressed("key_2"):
		selected_slot = 1
	if Input.is_action_just_pressed("key_3"):
		selected_slot = 2
	if Input.is_action_just_pressed("key_4"):
		selected_slot = 3
	if Input.is_action_just_pressed("key_5"):
		selected_slot = 4
	if Input.is_action_just_pressed("key_6"):
		selected_slot = 5
	if Input.is_action_just_pressed("key_7"):
		selected_slot = 6
	if Input.is_action_just_pressed("key_8"):
		selected_slot = 7
	if Input.is_action_just_pressed("key_9"):
		selected_slot = 8
	if Input.is_action_just_pressed("key_0"):
		selected_slot = 9
