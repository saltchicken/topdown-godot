class_name InventoryItem
extends TextureRect

enum Type {HEAD, CHEST, WAIST, LEGS, FEET, WEAPON, NECK, MAIN}

signal collect

@export var type: Type
@export var item_name: String
@export_multiline var description: String
@export var stackable: bool = false


@onready var stack_number_panel = get_node("StackNumberPanel")
@onready var stack_number_label = get_node("StackNumberPanel/StackNumberLabel")
@onready var stack_count = 1: set = _set_stack_count
func _set_stack_count(new_value):
	if new_value > 1:
		stack_number_panel.visible = true
		stack_number_label.text = str(new_value)
	elif new_value == 1:
		stack_number_panel.visible = false
		stack_number_label.text = ""
	else:
		push_error("Issue with _set_stack_count. Should never be 0 or lower. New value is: ", new_value)
		
	stack_count = new_value
	
func _ready():
	#expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	#stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	collect.connect(_on_collect)
	tooltip_text = "%s\n%s" % [item_name, description]
	size = Vector2(32.0, 32.0)
	print(size)
	get_node("CollectableComponent").position = size / 2
		#stackable = data.stackable
		
	#collect.connect(on_collect)

func _get_drag_data(at_position: Vector2):
	set_drag_preview(make_drag_preview(at_position))
	return self
	
func make_drag_preview(at_position: Vector2):
	var t := TextureRect.new()
	t.texture = texture
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = size
	t.modulate.a = 0.75
	t.position = Vector2(-at_position)
	
	var c := Control.new()
	c.add_child(t)
	
	return c
	
func _on_collect():
	print("Collect item")
		
#func on_collect():
	#var collectable_component = get_node("CollectableComponent")
	#remove_child(collectable_component)
	#collectable_component.queue_free()
