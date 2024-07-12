extends Node2D


func collect(collector):
	if owner.has_signal("collect") and collector.has_signal("collect"):
		collector.collect.emit(owner)
		owner.collect.emit()
	else:
		push_warning("Collect signal as not been implemented")
