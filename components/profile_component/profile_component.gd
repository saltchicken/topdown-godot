extends Node

@onready var saved_position = Vector2.ZERO
@onready var inventory = {}
@onready var equipment = {}

@onready var level_mapping = PlayerLevelMapping.new()
@onready var experience = 0
@onready var level: int = 0:
	set(value):
		pass
	get:
		@warning_ignore("integer_division")
		return level_mapping.get_level(experience)

@onready var coins = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('Persist')
	#var exp_needed = level_mapping.experience_needed_for_next_level(experience)
	#prints("need for next level:", exp_needed)
	#
	#prints("Level: ", level)
	pass
	
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"name" : owner.name,
		"pos_x" : owner.position.x,
		"pos_y" : owner.position.y,
		"coins" : coins
	}
	return save_dict
