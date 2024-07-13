extends Node


var dialogue_node = preload("res://text/dialogue_panel/dialogue_panel.tscn")
func dialogue(parent_node, text_array: Array):
	var dialogue_instance = dialogue_node.instantiate()
	parent_node.add_child(dialogue_instance)
	dialogue_instance.set_text(text_array)
	dialogue_instance.main()


func save_game():
	var save_gamed = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
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

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_gamed.store_line(json_string)
		print('saved')
		
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	#var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for i in save_nodes:
		#i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_gamed = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_gamed.get_position() < save_gamed.get_length():
		var json_string = save_gamed.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()
		
		#var name = node_data.get("name")
		
		match node_data["name"]:
			"Player":
				var player = get_node("/root/Gameplay/Player")
				player.position.x = node_data["pos_x"]
				player.position.y = node_data["pos_y"]
			"ProfileComponent":
				var player_profile = get_node("/root/Gameplay/Player/ProfileComponent")
				player_profile.coins = node_data["coins"]
			_:
				print("Not implemented for loading")
			
			
		

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
			
