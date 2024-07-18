extends Node

@export var game_time_multiplier = 10000
var time_elapsed: float = 0.0
var current_day: int = 0
var current_hour: int = 0:
	set(value):
		pass
	get():
		return time_elapsed / 3600
var current_time:
	set(value):
		pass
	get():
		return round(time_elapsed)
		
func time_tick(delta):
	time_elapsed += delta * game_time_multiplier
	if time_elapsed >= 86400.0:
			time_elapsed = time_elapsed - 86400
			current_day += 1

func _process(delta):
	time_tick(delta)
