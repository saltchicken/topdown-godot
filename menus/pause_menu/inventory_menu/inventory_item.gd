class_name InventoryItem
extends TextureRect

@onready var data: ItemData
#@onready var stackable := false

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

signal collect

func init(node_path: String) -> void:
	data = load(node_path).instantiate()
	
func _ready():
	#expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	#stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if data:
		texture = data.texture
		tooltip_text = "%s\n%s" % [data.name, data.description]
		#stackable = data.stackable
		
	collect.connect(on_collect)

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
		
func on_collect():
	var collectable_component = get_node("CollectableComponent")
	remove_child(collectable_component)
	collectable_component.queue_free()
