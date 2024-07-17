extends StaticBody2D

@export var initial_state: State
@onready var state_machine = $StateMachine
@onready var area_2d: Area2D = $Area2D

signal interact


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('light')
	#add_to_group("Bonfires") # TODO: Find a better way for game_manager to know of its existence.
	area_2d.body_entered.connect(bonfire_body_entered)
	area_2d.body_exited.connect(bonfire_body_exited)
	
	interact.connect(on_interact)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_interact():
	if is_bonfire_on():
		print("Bonfire is already lit")
	else:
		turn_bonfire_on()
	print("Saving game")
	Global.save_game()
	
func turn_bonfire_on():
	if state_machine.current_state.name == 'off':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'on')
		
func is_bonfire_on():
	if state_machine.current_state.name == 'on':
		return true
	else:
		return false


#func use():
	#if state_machine.current_state.name == 'off':
		#state_machine.current_state.state_transition.emit(state_machine.current_state, 'on')
		#var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character
		#if self.data.get_path() in player.bonfire_menu.known_bonfires:
			#print("Error: This bonfire already discovered")
		#else:
			#player.bonfire_menu.known_bonfires.append(self.data.get_path())
		#area_2d.body_entered.emit(player)
	#if state_machine.current_state.name == 'on':
		## TODO: This should be called no matter what state the bonfire is used. Though this should be handled with bonfire menu unless auto save is needed
		#SceneManager.save_game(self)
		#print('Game saved')
		## TODO: Need a bonfire menu
		#
func bonfire_body_entered(_body):
	print_debug('Entered bonfire area')
	#if body.get_script() == Player:
		#if state_machine.current_state.name == 'on':
			#for enemy in get_tree().get_nodes_in_group("Enemies"):
				#if enemy.get_node("VisibleOnScreenNotifier2D").is_on_screen() == false:
					#enemy.despawn()
				#else:
					#if enemy.has_method("run_away"):
						#enemy.run_away()
					#else:
						#print("Error: Enemy doesn't have run_away method")
	
func bonfire_body_exited(_body):
	print_debug('Exitted bonfire area')
	#if body.get_script() == Player:
		#if state_machine.current_state.name == 'on':
			#for enemy in get_tree().get_nodes_in_group("Enemies"):
				#if enemy.state_machine.current_state.name == 'run_away':
					##print('Disconnecting despawn')
					#enemy.get_node('VisibleOnScreenNotifier2D').screen_exited.disconnect(enemy.despawn)
					#enemy.idle()
					
#func save():
	#var save_dict = {
		#"node_name" : self.name,
		#"unique_name" : self.unique_name,
		#"state" : self.state_machine.current_state.name,
		#"location_x"  : self.global_position.x,
		#"location_y"  : self.global_position.y
	#}
	#return save_dict
	#
#func load(node_data):
	#print(node_data['state'])
