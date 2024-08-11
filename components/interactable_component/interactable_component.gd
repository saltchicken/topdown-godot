extends Node2D

func interact(interactor):
	if owner.has_signal("interact"):
		owner.interact.emit(interactor)
	else:
		push_warning("Interact signal as not been implemented")
