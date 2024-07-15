extends CanvasLayer

#@onready var scene_instance = preload("res://scenes/game/game_manager.tscn").instantiate()
#@onready var player_instance = preload("res://characters/player/player.tscn").instantiate()

func _ready():
	var buttons = get_node('Panel/VBoxContainer').get_children()
	#for button in buttons:
		#button.pressed.connect(button_pressed.bind(button))
	for button in buttons:
		button.button_up.connect(_on_button_button_up.bind(button))
		
#func custom_change_scene(scene):
	#get_tree().root.add_child(scene_instance)
	#get_tree().current_scene = scene_instance
	#scene_instance.add_child(player_instance)
	#scene_instance.player = player_instance
	
func _on_button_button_up(button):
	match button.text:
		"New Game":
			print('TODO: Add warning that old save will be erased')
			#custom_change_scene(scene_instance)
			#queue_free()
			#SceneManager.should_load_game = false
			#SceneManager.swap_scenes("res://scene_manager/gameplay/gameplay.tscn",get_tree().root,self,"fade_to_black")
			SceneManager.swap_scenes("res://menus/profile_creation_menu/profile_creation.tscn",get_tree().root,self,"fade_to_black")
			
		"Continue":
			#custom_change_scene(scene_instance)
			# TODO: Better way of handling load game when continuing
			#push_warning("Loading has not been handled yet")
			#SceneManager.should_load_game = true
			#SceneManager.swap_scenes("res://scene_manager/gameplay/gameplay.tscn",get_tree().root,self,"fade_to_black")
			SceneManager.swap_scenes("res://menus/profile_selection_menu/profile_selection_menu.tscn",get_tree().root,self,"fade_to_black")

			
			#queue_free()
			
		"Exit To Deskop":
			get_tree().quit()
			
