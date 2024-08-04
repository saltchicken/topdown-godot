extends Node2D


func collect(collector):
	var parent = get_parent()
	if parent.has_signal("collect") and collector.has_signal("collect"):
		collector.collect.emit(parent)
		parent.collect.emit()
	else:
		push_warning("Collect signal as not been implemented")
