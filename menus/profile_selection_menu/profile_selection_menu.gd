extends CanvasLayer

@onready var existing_profiles = get_existing_profiles()
@onready var profile_container = $Panel/VBoxContainer

@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog

signal confirmation_dialog_closed
var confirmation

func _ready() -> void:
	for profile in existing_profiles:
		var container = HBoxContainer.new()
		
		var label = RichTextLabel.new()
		label.text = profile
		label.fit_content = true
		label.autowrap_mode = TextServer.AUTOWRAP_OFF
		container.add_child(label)
		
		var button = Button.new()
		button.text = "Delete"
		button.pressed.connect(on_delete_button_pressed.bind(label))
		container.add_child(button)
		
		
		
		profile_container.add_child(container)
		
		
func on_delete_button_pressed(label):
	confirmation = null
	var profile_to_be_deleted = label.text
	confirmation_dialog.confirmed.connect(func(): confirmation = true; confirmation_dialog_closed.emit())
	confirmation_dialog.canceled.connect(func(): confirmation = false; confirmation_dialog_closed.emit())
	confirmation_dialog.visible = true
	await confirmation_dialog_closed
	if confirmation:
		print("Delete %s" % profile_to_be_deleted)
	else:
		print("Don't delete %s" % profile_to_be_deleted)

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
		

					
	
