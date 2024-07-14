class_name Level extends Node2D

## This class is not part of [class SceneManager], it's just here to make the sample
## project do something. All levels (i.e. the game content) extend from this class. 
## You will note that because Levels "want" to pass data between them, they implement
## the optional methods [method get_data] and [method receive_data]

var rng = RandomNumberGenerator.new()

var MAX_ENEMIES = 1000
var ENEMIES_COUNT = 0

var player:Player
@onready var portals = get_node("Portals").get_children()
var data:LevelDataHandoff

@onready var gameplay = get_parent().get_parent() # TODO: Better way to reference or not need this at all

func _ready() -> void:
	player = gameplay.player
	#add_child(player)
	player.disable()
	#player.visible = false
	set_player_position()
	
	#register_bonfires()
	#check_known_bonfires()
	
	# This block is here to allow us to test current scene without needing the SceneManager to call these :) 
	if data == null:
		init_scene()
		start_scene()
		
func set_player_position():
	#if player.load_location:
		#player.global_position = player.load_location
	#else:
	push_warning("Using default 0,0 for player position")	

## When a class implements this, SceneManager.on_content_finished_loading will invoke it
## to receive this data and pass it to the next scene
func get_data():
	return data
	
## 1) emitted at the beginning of SceneManager.on_content_finished_loading
## When a class implements this, SceneManager.on_content_finished_loading will invoke it
## to insert data received from the previous scene into this one	
func receive_data(_data):
	# implementing class should do some basic checks to make sure it only acts on data it's prepared to accept
	# if previous scene sends data this scene doesn't need, simple logic as follows ensures no crash occurs
	# act only on the data you want to receive and process :) 
	if _data is LevelDataHandoff:
		data = _data
	else:
		push_warning("Level %s is receiving data it cannot process" % name)

# Emitted in the middle of SceneManager.on_content_finished_loading
func init_scene() -> void:
	print("Init scene")
	if data != null and player != null:
		for portal in portals:
			if portal.name == data.target_portal:
				player.position = portal.global_position + portal.move_position
		#player.position = data.position_in_new_scene

# Emitted at end of SceneManager.on_content_finished_loading
func start_scene() -> void:
	player.enable()
	print("Start scene")
	connect_portals()
	Global.play_song(0)

# signal emitted by Door, # disables doors and players, create handoff data to pass to the new scene (if new scene is a Level)
func on_player_entered_portal(portal:Portal) -> void:
	disconnect_portals()
	player.disable()
	data = LevelDataHandoff.new()
	data.target_portal = portal.target_portal
	data.move_position = portal.move_position
	#data.move_dir = portal.get_move_dir()
	
func connect_portals() -> void:
	for portal in portals:
		if not portal.player_entered.is_connected(on_player_entered_portal):
			portal.player_entered.connect(on_player_entered_portal)
			#print_debug("Connected %s" % portal.name)
				
func disconnect_portals() -> void:
	for portal in portals:
		if portal.player_entered.is_connected(on_player_entered_portal):
			portal.player_entered.disconnect(on_player_entered_portal)
			#print_debug("Disconnected %s" % portal.name)
			
#func register_bonfires():
	#for bonfire in get_tree().get_nodes_in_group("Bonfires"):
		#bonfire.area_2d.body_entered.connect(bonfire_body_entered.bind(bonfire))
		#bonfire.area_2d.body_exited.connect(bonfire_body_exited)
		
#func check_known_bonfires():
	#for bonfire in get_tree().get_nodes_in_group("Bonfires"):
		#if bonfire.data.get_path() in player.bonfire_menu.known_bonfires:
				## TODO: Make a function that inits a new initial state and also updates the current_state
				#bonfire.initial_state = bonfire.state_machine.get_node('on')
				#bonfire.state_machine.current_state = bonfire.state_machine.get_node('on')
				#
#func bonfire_body_entered(body, bonfire):
	#if body.get_script() == Player:
		#if bonfire.state_machine.current_state.name == 'on':
			#for timer in timers.keys():
				#timers[timer].stop()
	#
#func bonfire_body_exited(body):
	#if body.get_script() == Player:
		#for timer in timers.keys():
				#timers[timer].start()
			
#func spawn_mob(mob):
	##var enemy_type = rng.randi_range(0, 1)
	##var enemy = enemy_scenes[enemy_type].instantiate()
	#ENEMIES_COUNT += 1
	#var mob_instance = mob.instantiate()
	#player.path_follow.progress_ratio = randf()
	#mob_instance.global_position = player.path_follow.global_position
	#add_child(mob_instance)
	#mob_instance.add_to_group("Enemies")
	#
## TODO: Not being used. Move to utility or something
#func calculate_random_position_at_range(range_magnitude):
	#var direction = rng.randf_range(0.0, 6.283)
	#var x = range_magnitude * cos(direction)
	#var y = range_magnitude * sin(direction)
	#return Vector2(x, y)
			
