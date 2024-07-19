class_name InventoryItem
extends TextureRect

@export var data: ItemData

func init(d: ItemData) -> void:
	data = d
	
func _ready():
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if data:
		texture = data.texture
		tooltip_text = "%s\n%s" % [data.name, data.description]

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
