extends Area2D

func _physics_process(_delta: float) -> void:
	var areas = get_overlapping_areas()
	for area in areas:
		area.collect(owner)
