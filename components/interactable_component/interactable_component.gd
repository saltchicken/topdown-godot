extends Node2D

func interact():
	if owner.get_signal_list()[0]["name"] == "interact":
		owner.interact.emit()
	else:
		push_warning("Interact signal as not been implemented")
