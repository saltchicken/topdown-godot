extends Node2D

func interact():
	if owner.has_signal("interact"):
		owner.interact.emit()
	else:
		push_warning("Interact signal as not been implemented")
