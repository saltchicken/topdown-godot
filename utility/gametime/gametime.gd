extends Node

@export var game_time_multiplier = 100000
@onready var time_elapsed: float = 0.0
@onready var current_day: int = 1
@onready var current_hour: int = 1
@onready var current_month: int = 1
@onready var current_year: int = 1
		
func _ready():
	add_to_group('PlayerProfilePersist')
		
func time_tick(delta):
	time_elapsed += delta * game_time_multiplier
	if time_elapsed >= 3600.0:
			time_elapsed = time_elapsed - 3600.0
			current_hour += 1
	if current_hour > 24:
		current_day += 1
		current_hour = 1
	if current_day > 30:
		current_month += 1
		current_day = 1
	if current_month > 12:
		current_year += 1
		current_month = 1

func _process(delta):
	prints(current_hour, current_day, current_month, current_year)
	time_tick(delta)

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"node_path" : get_path(),
		"name" : name,
		"time_elapsed" : time_elapsed,
		"current_hour" : current_hour,
		"current_day" : current_day,
		"current_month" : current_month,
		"current_year" : current_year
	}
	return save_dict
