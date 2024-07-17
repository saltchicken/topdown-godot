extends CanvasLayer

@onready var existing_profiles = get_existing_profiles()
@onready var profile_container = $Panel/VBoxContainer

@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog

signal confirmation_dialog_closed
var confirmation

func _ready() -> void:
	load_existing_profiles()
	
func load_existing_profiles():
	for profile in existing_profiles:
		var container = HBoxContainer.new()
		
		var label = RichTextLabel.new()
		label.text = profile
		label.fit_content = true
		label.autowrap_mode = TextServer.AUTOWRAP_OFF
		container.add_child(label)
		
		var load_button = Button.new()
		load_button.text = "Load"
		load_button.pressed.connect(on_load_button_pressed.bind(label))
		container.add_child(load_button)
		
		var delete_button = Button.new()
		delete_button.text = "Delete"
		delete_button.pressed.connect(on_delete_button_pressed.bind(label))
		container.add_child(delete_button)
	
		profile_container.add_child(container)
		
func on_load_button_pressed(label):
	SceneManager.should_load_game = true
	Global.current_profile = label.text
	Global.remove_temp_world() # TODO: This is a little hacky. Possibly do this on exit of the game, but maybe leave in a check to make sure it happened.
	SceneManager.swap_scenes("res://scene_manager/gameplay/gameplay.tscn",get_tree().root,self,"fade_to_black")
		
func on_delete_button_pressed(label):
	confirmation = null
	var profile_to_be_deleted = label.text
	confirmation_dialog.confirmed.connect(func(): confirmation = true; confirmation_dialog_closed.emit())
	confirmation_dialog.canceled.connect(func(): confirmation = false; confirmation_dialog_closed.emit())
	confirmation_dialog.visible = true
	await confirmation_dialog_closed
	if confirmation:
		delete_profile(profile_to_be_deleted)
		SceneManager.swap_scenes("res://menus/profile_selection_menu/profile_selection_menu.tscn",get_tree().root,self,"no_transition")
	else:
		print("Don't delete %s" % profile_to_be_deleted)

func delete_profile(profile_name):
	var directory_to_remove = Global.profiles_dir + profile_name
	var dir = DirAccess.open(directory_to_remove)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			DirAccess.remove_absolute(directory_to_remove + '/' + file_name)
			file_name = dir.get_next()
	else:
		push_error("Unable to open profile directory")
	var error = DirAccess.remove_absolute(Global.profiles_dir + profile_name)
	if error:
		push_error(error)

func get_existing_profiles():
	var profiles = []
	var dir = DirAccess.open(Global.profiles_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				profiles.append(file_name)
			else:
				push_error("There shouldn't be any files in %s." % Global.profiles_dir)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
	return profiles
		

					
	
