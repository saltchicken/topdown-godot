extends ItemData

@onready var on = false

func use(player, item_slot):
	if on:
		player.remove_from_group("light")
		on = false
	else:
		player.add_to_group("light")
		on = true
