extends Node

@onready var profiles_dir = "user://profiles/"
@onready var current_profile = null

@onready var audio = get_node("Audio").get_children()
var current_song = null

func play_song(track_number):
	audio[track_number].play()
	current_song = track_number
	
func stop_song():
	if current_song != null:
		audio[current_song].stop()
	else:
		push_warning("Song is not playing")

var dialogue_node = preload("res://text/dialogue_panel/dialogue_panel.tscn")
func dialogue(parent_node, text_array: Array):
	var dialogue_instance = dialogue_node.instantiate()
	parent_node.add_child(dialogue_instance)
	dialogue_instance.set_text(text_array)
	dialogue_instance.main()


# TODO Make backup saves in case of corruption
func save_game():
	save_player_profile()
	save_world()
	
func save_player_profile():
	if current_profile == null:
		push_error("Current profile not set")
		return
	var saved_game_file_path = profiles_dir + current_profile + "/player_profile.save"
	prints("File path", saved_game_file_path)
	var saved_game = FileAccess.open(saved_game_file_path, FileAccess.WRITE)
	prints("saved game", saved_game)
	var save_nodes = get_tree().get_nodes_in_group("PlayerProfilePersist")
	for node in save_nodes:
		prints("Saving", node)
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
			
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		saved_game.store_line(json_string)
	saved_game.close() # TODO: Is this necessary or does FileAccess handle this automatically
		
func save_world(temp: bool = false):
	if current_profile == null:
		push_error("Current profile not set")
		return
	var current_level = get_node('/root/Gameplay').current_level
	var saved_game_file_path
	if !temp:
		saved_game_file_path = profiles_dir + current_profile + "/world.save"
		######################################################################
		# This block creates a new world save if one does not exist
		if not FileAccess.file_exists(saved_game_file_path):
			var world_save = FileAccess.open(saved_game_file_path, FileAccess.WRITE)
			var level_data = current_level.call("save")
			prints("LevelData:", level_data)
			world_save.store_line(JSON.stringify(level_data))
			world_save.close()
			return
		######################################################################	
	else:
		saved_game_file_path = profiles_dir + current_profile + "/temp_world.save"

	
	# This block iterates through the existing world save and makes the array `lines` that we can edit
	######################################################################
	var saved_game
	if FileAccess.file_exists(profiles_dir + current_profile + "/temp_world.save"):
		print('#################temp existed')
		saved_game = FileAccess.open(profiles_dir + current_profile + "/temp_world.save", FileAccess.READ)
	else:
		print("################temp didn't exist")
		if not FileAccess.file_exists(profiles_dir + current_profile + "/world.save"):
			print('twas null')
			var world_save = FileAccess.open(profiles_dir + current_profile + "/world.save", FileAccess.WRITE)
			var level_data = current_level.call("save")
			prints("LevelData:", level_data)
			world_save.store_line(JSON.stringify(level_data))
			world_save.close()
		saved_game = FileAccess.open(profiles_dir + current_profile + "/world.save", FileAccess.READ)
	#var saved_game = FileAccess.open(saved_game_file_path, FileAccess.READ)
	var line_to_modify = null
	var lines = []
	
	var line_count = 0
	while saved_game.get_position() < saved_game.get_length():
		var json_string = saved_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var line_data = json.get_data()
		if line_data['name'] == current_level.name: # ALERT Verify that these are comparing the correct values
			print("FOUND THE CURRENT LEVEL NAME")
			line_to_modify = line_count
		
		lines.append(json_string)
		line_count += 1
	#######################################################################
	
	# Now overwrite the line we found that already has an entry for the current level
	#######################################################################
	var level_data = current_level.call("save")
	if line_to_modify != null:
		lines[line_to_modify] = JSON.stringify(level_data)
	else:
		lines.append(JSON.stringify(level_data))
		
	saved_game.close()
	#######################################################################
	
	# Overwrite the world file with the newly modified one
	#######################################################################	
	var world_save = FileAccess.open(saved_game_file_path, FileAccess.WRITE)
	for line in lines:
		world_save.store_line(line)
	world_save.close()
	#######################################################################
		
func load_game():
	var level_to_load_path = load_player_profile()
	#load_world()
	return level_to_load_path
	
func load_player_profile():
	if current_profile == null:
		push_error("Current profile not set")
		return
	var saved_game_file_path = profiles_dir + current_profile + "/player_profile.save"
	if not FileAccess.file_exists(saved_game_file_path):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	#var save_nodes = get_tree().get_nodes_in_group("PlayerProfilePersist")
	#for i in save_nodes:
		#i.queue_free()
	var current_level # NOTE This is a little dirty, but it extracts the current level the player saved.
	
	var saved_game = FileAccess.open(saved_game_file_path, FileAccess.READ)
	while saved_game.get_position() < saved_game.get_length():
		var json_string = saved_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var node_data = json.get_data()
		#print(node_data)
		
		var node_name = node_data.get("name")
		var node_path = node_data.get("node_path")
		
		if node_name == null or node_path == null:
			prints("Node saved incorrectly:", parse_result)
			
		
		
		match node_name:
			"Player":
				var player = get_node(node_path)
				player.position.x = node_data["pos_x"]
				player.position.y = node_data["pos_y"]
				current_level = node_data["current_level"]
			"ProfileComponent":
				var player_profile = get_node(node_path)
				player_profile.coins = node_data["coins"]
			_:
				print("Not implemented for loading")
				
	return current_level
			
			
		

		# Firstly, we need to create the object and add it to the tree and set its position.
		#var new_object = load(node_data["filename"]).instantiate()
		#get_node(node_data["parent"]).add_child(new_object)
		#new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
#
		## Now we set the remaining variables.
		#for i in node_data.keys():
			#if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				#continue
			#new_object.set(i, node_data[i])

func load_world(level_to_load, temp:bool = false):
	var saved_game_file_path
	if !temp:
		saved_game_file_path = profiles_dir + current_profile + "/world.save"
	else:
		saved_game_file_path = profiles_dir + current_profile + "/temp_world.save"
	if not FileAccess.file_exists(saved_game_file_path):
		push_error("That world save does not exist")
		return # Error! We don't have a save to load.
	var saved_game = FileAccess.open(saved_game_file_path, FileAccess.READ)
	while saved_game.get_position() < saved_game.get_length():
		var json_string = saved_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var line_data = json.get_data()
		if line_data['name'] == level_to_load: # ALERT Verify that these are comparing the correct values
			print("FOUND THE CURRENT LEVEL NAME FOR INIT SCENE")
			return line_data


func remove_temp_world():
	var temp_world_file_path = profiles_dir + current_profile + "/temp_world.save"
	DirAccess.remove_absolute(temp_world_file_path)
	
