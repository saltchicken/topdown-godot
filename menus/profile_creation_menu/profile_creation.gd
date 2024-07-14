extends CanvasLayer

@onready var profile_name_line_edit = get_node("Panel/VBoxContainer/LineEdit")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	profile_name_line_edit.text_submitted.connect(on_text_submit)


func on_text_submit(text):
	print(text)
	Global.current_profile = text
	SceneManager.swap_scenes("res://scene_manager/gameplay/gameplay.tscn",get_tree().root,self,"fade_to_black")
