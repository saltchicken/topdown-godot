class_name PlayerLevelMapping extends Node

var experience_level_buckets = [
	0,
	1000,
	5000,
	12000,
	25000,
	52000
]

func get_level(experience):
	for i in experience_level_buckets.size():
		if experience_level_buckets[i] > experience:
			return i
	return experience_level_buckets.size()
			
func experience_needed_for_next_level(experience):
	for i in experience_level_buckets.size():
		if experience_level_buckets[i] > experience:
			return experience_level_buckets[i] - experience
	push_warning("At max level. Returning 0 for experience needed for next level. Is this correct?")
	return 0
