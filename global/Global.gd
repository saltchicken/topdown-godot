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

func save_game():
	if current_profile == null:
		push_error("Current profile not set")
		return
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
			
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		save_gamed.store_line(json_string)
		
func load_game():
	if current_profile == null:
		push_error("Current profile not set")
		return
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	#var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for i in save_nodes:
		#i.queue_free()

	var save_gamed = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_gamed.get_position() < save_gamed.get_length():
		var json_string = save_gamed.get_line()
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
			"ProfileComponent":
				var player_profile = get_node(node_path)
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
			
