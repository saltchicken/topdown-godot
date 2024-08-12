extends Node2D

@export var tile_item: TileItem

func place(player):
	var current_level = get_node('/root/Gameplay').current_level
	if !is_instance_valid(current_level):
		push_warning("_highlight_select_layer is calling 'current level' which is freed. Probably can fix when this is refactored to be assigned on level load")
		return
	var player_object_layer = current_level.get_node_or_null('PlayerObjectLayer') # TODOs: This should be set on level load so it doesn't keep getting called. This is inefficient.
	if player_object_layer == null:
		push_error("There is no player object layer. Should work when using inheritence from level parent")
		return
	var tile_map_coords = player_object_layer.local_to_map(player.global_position)
	tile_map_coords += Vector2i(player.direction)
	if _tile_available(tile_map_coords): # TODO: This needs to check if the coord is already taken
		#tile_select_layer.set_cell(current_highlighted_tile_coords, -1, Vector2i(-1,-1), -1)
		#print("planting seed   ", str(tile_map_coords))
		player_object_layer.set_cell(tile_map_coords, 0, Vector2i(0,0), 3)
		return true
		#current_highlighted_tile_coords = tile_map_coords
	else:
		return false
		
		
	# TODO: If this works then need to consume like Health Potion

func _tile_available(tile_map_coords):
	var current_level = get_node('/root/Gameplay').current_level
	var player_object_layer = current_level.get_node_or_null('PlayerObjectLayer')
	#print(player_object_layer.get_cell_tile_data(tile_map_coords))
	#print(player_object_layer.get_used_cells())
	#print(player_object_layer.get_cell_source_id(tile_map_coords))
	if player_object_layer.get_cell_source_id(tile_map_coords) == -1:
		return true
	elif player_object_layer.get_cell_source_id(tile_map_coords) == 0:
		return false
	else:
		push_error("This hasn't been implemented yet, just going to say this cell is available")
		return true
