extends Seed

func use(player, item_slot):
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
		print("planting seed   ", str(tile_map_coords))
		player_object_layer.set_cell(tile_map_coords, 0, Vector2i(0,0), 3)
		#current_highlighted_tile_coords = tile_map_coords
	else:
		pass
		
		
	# TODO: If this works then need to consume like Health Potion

func _tile_available(tile_map_coords):
	return true
