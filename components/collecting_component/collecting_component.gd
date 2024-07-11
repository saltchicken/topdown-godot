extends Area2D

@onready var count_coins = 0

func _physics_process(_delta: float) -> void:
	var areas = get_overlapping_areas()
	for area in areas:
		if area is Coins:
			collect_coins(area)


func collect_coins(coins):
	coins.collect()
	count_coins += coins.value
	print(count_coins)
	
