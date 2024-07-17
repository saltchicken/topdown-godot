extends CanvasLayer

#@onready var scene_instance = preload("res://scenes/game/game_manager.tscn").instantiate()
#@onready var player_instance = preload("res://characters/player/player.tscn").instantiate()

func _ready():
	var buttons = get_node('Panel/VBoxContainer').get_children()
	#for button in buttons:
		#button.pressed.connect(button_pressed.bind(button))
	for button in buttons:
		button.button_up.connect(_on_button_button_up.bind(button))
			
func _on_button_button_up(button):
	match button.text:
		"New Game":
			SceneManager.swap_scenes("res://menus/profile_creation_menu/profile_creation.tscn",get_tree().root,self,"no_transition")
		
		"Continue":
			SceneManager.swap_scenes("res://menus/profile_selection_menu/profile_selection_menu.tscn",get_tree().root,self,"no_transition")
			
		"Exit To Deskop":
			get_tree().quit()
			
