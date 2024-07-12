extends Area2D

func _physics_process(_delta: float) -> void:
	var areas = get_overlapping_areas()
	for area in areas:
		if area is Coins:
			collect_coins(area)


func collect_coins(coins):
	coins.collect()
	owner.collect.emit(coins.name, coins.value)
	
