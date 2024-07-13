extends Area2D

func _physics_process(_delta: float) -> void:
	var areas = get_overlapping_areas()
	for area in areas:
		var collectable_component = area.get_node_or_null('CollectableComponent')
		if collectable_component:
			collectable_component.collect(owner)


#func collect_coins(coins):
	#coins.collect()
	#owner.collect.emit(coins.name, coins.value)
	