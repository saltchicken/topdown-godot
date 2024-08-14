extends Node2D

@onready var player = get_owner()
@onready var current_highlighted_tile_coords = Vector2i(0,0)

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_highlight_select_layer()


func _highlight_select_layer():
	var current_level = get_node('/root/Gameplay').current_level
	if !is_instance_valid(current_level):
		push_warning("_highlight_select_layer is calling 'current level' which is freed. Probably can fix when this is refactored to be assigned on level load")
		return
	var tile_select_layer = current_level.get_node_or_null('TileSelectLayer') # TODOs: This should be set on level load so it doesn't keep getting called. This is inefficient.
	if tile_select_layer == null:
		push_error("There is no tile select layer. Should work when using inheritence from level parent")
		return
	var tile_map_coords = tile_select_layer.local_to_map(global_position)
	tile_map_coords += Vector2i(player.direction)
	if tile_map_coords != current_highlighted_tile_coords:
		tile_select_layer.set_cell(current_highlighted_tile_coords, -1, Vector2i(-1,-1), -1)
		tile_select_layer.set_cell(tile_map_coords, 0, Vector2i(0,0), 0)
		current_highlighted_tile_coords = tile_map_coords
	else:
		pass
