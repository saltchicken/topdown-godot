extends CanvasLayer

@onready var profile_name_line_edit = get_node("Panel/VBoxContainer/LineEdit")

func _ready() -> void:
	profile_name_line_edit.text_submitted.connect(on_text_submit)
	$Panel/BackButton.pressed.connect(func(): SceneManager.swap_scenes("res://scene_manager/main_menu/main_menu.tscn",get_tree().root,self,"no_transition"))

func on_text_submit(text):
	if text.length() >= 4:
		if profile_name_validation(text):
			var error = create_profile(text)
			if !error:
				Global.current_profile = text
				SceneManager.should_load_game = false
				SceneManager.swap_scenes("res://scene_manager/gameplay/gameplay.tscn",get_tree().root,self,"fade_to_black")
			else:
				push_error(error)
		else:
			pass
	else:
		print("Profile name must be at least four letters")
		
func profile_name_validation(profile_name):
	var regex = RegEx.new()
	regex.compile("[^A-Za-z0-9]")
	var result = regex.search(profile_name)
	if result:
		print("Alphanumeric characters only! Found: [", result.get_string(0), "]")
		return false
	else:
		return true
	
func create_profile(profile_name):
	var profile_path = Global.profiles_dir + profile_name + "/"
	if !check_if_profile_exists(profile_name):
		var error = DirAccess.make_dir_recursive_absolute(profile_path)
		push_error(error)
		return false
	else:
		push_error("Profile already exists")
		return true
	
func check_if_profile_exists(profile_name):
	var profile_path = Global.profiles_dir + profile_name
	var dir = DirAccess.open(Global.profiles_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if file_name == profile_name:
					return true
			else:
				push_error("There shouldn't be any files in %s. Found: %s" % [Global.profiles_dir, profile_path])
			file_name = dir.get_next()
		return false
	else:
		print("An error occurred when trying to access the path.")
