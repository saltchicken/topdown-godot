extends Node2D

var queue = []
var default_color = Color.WHITE

@onready var timer = get_node("Timer")

#func _ready():
	#timer.timeout.connect(queue_redraw)
	#timer.start()

func _draw():
	if queue.size() > 50:
		push_warning("Way to many element in Debug Queue")		
	for element in queue:
		match element.type:
			DebugElement.draw_type.POINT:
				draw_circle(element.pos, 5, element.color)
			DebugElement.draw_type.LINE:
				draw_line(element.body.global_position, element.body.global_position + element.pos, element.color, 1.0)
			DebugElement.draw_type.CIRCLE:
				var point_count = 16
				draw_arc(element.body.global_position, element.pos.length(), 0.0, TAU, point_count, element.color, 1.0)

func _process(delta: float) -> void:
	queue_redraw()
	
func point(id, body, pos, color = default_color):
	var element = DebugElement.new()
	element.type = DebugElement.draw_type.POINT
	element.id = id
	element.body = body
	element.pos = pos
	element.color = color
	add_element_to_queue(element)
	
func line(id, body, pos, color = default_color):
	var element = DebugElement.new()
	element.type = DebugElement.draw_type.LINE
	element.id = id
	element.body = body
	element.pos = pos
	element.color = color
	add_element_to_queue(element)
	
func circle(id, body, pos, color = default_color):
	var element = DebugElement.new()
	element.type = DebugElement.draw_type.CIRCLE
	element.id = id
	element.body = body
	element.pos = pos
	element.color = color
	add_element_to_queue(element)
	
func add_element_to_queue(element):
	var element_exists = false
	var elements_to_remove = []
	for i in queue.size():
		#if queued_element.type == element.type and queued_element.body == element.body and queued_element.pos.is_equal_approx(element.pos):
		if queue[i].id == element.id and queue[i].body == element.body:
			if queue[i].pos.is_equal_approx(element.pos):
				element_exists = true
				print("Element already queued")
			else:
				elements_to_remove.append(i)
	for element_to_remove in elements_to_remove:
		queue.remove_at(element_to_remove)
	if !element_exists:
		queue.append(element)
	
#func calculate_end_point(slope, magnitude):
	#var x = magnitude / sqrt(1 + slope ** 2)
	#var y = slope * x
	#return Vector2(x, y)
	
#func set_perpendicular_line():
	#var slope = raycast.target_position.y / raycast.target_position.x
	#var perpendicular_slope = -1 / slope
	#var perpendicular_line_magnitude = 50
	#var end_point = calculate_end_point(perpendicular_slope, perpendicular_line_magnitude)
	#perpendicular_line.set_point_position(0, -end_point)
	#perpendicular_line.set_point_position(1, end_point)
