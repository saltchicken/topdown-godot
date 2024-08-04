extends Node


@onready var on = false

func use(parent):
	var player
	print(parent)
	match parent.name:
		"Player":
			player = parent
		"SelectionMenu":
			player = parent.get_parent().get_owner().get_owner()
		_:
			push_error("Use component not implemented for this parent")
			return

	if on:
		player.remove_from_group("light")
		on = false
	else:
		player.add_to_group("light")
		on = true
