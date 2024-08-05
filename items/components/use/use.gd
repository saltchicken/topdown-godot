extends Node

func use(parent, item_slot):
	var player
	match parent.name:
		"Player":
			player = parent
		"SelectionMenu":
			player = parent.get_parent().get_owner().get_owner()
		_:
			push_error("Use component not implemented for this parent")
			return
	
	owner.use(player, item_slot)
