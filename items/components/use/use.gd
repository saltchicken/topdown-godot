extends Node


@onready var on = false

func use(parent):
	var player = parent.get_parent().get_owner().get_owner()
	if on:
		player.remove_from_group("light")
		on = false
	else:
		player.add_to_group("light")
		on = true
