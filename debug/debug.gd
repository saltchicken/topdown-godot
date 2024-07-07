extends Node2D

#@onready var points = []
#@onready var point = null

var queue = []
var default_color = Color.WHITE

@onready var timer = get_node("Timer")

#func _ready():
	#timer.timeout.connect(queue_redraw)
	#timer.start()

func _draw():
	if queue.size() > 50:
		push_warning("Way to many element in Debug Queue")
	while queue.size() > 0:
		var element = queue.pop_back()
		match element.type:
			DebugElement.draw_type.POINT:
				draw_circle(element.pos, 5, element.color)
			DebugElement.draw_type.LINE:
				draw_line(element.body.global_position, element.pos, element.color, 1.0)
			DebugElement.draw_type.CIRCLE:
				var point_count = 16
				draw_arc(element.body.global_position, element.pos.length(), 0.0, TAU, point_count, element.color, 1.0)
		
	#for element in queue:
		#match element.type:
			#DebugElement.draw_type.POINT:
				#print(element.pos)
				#print(element.color)
				#draw_circle(element.pos, 5, element.color)
			#DebugElement.draw_type.LINE:
				#draw_line(element.body.global_position, element.pos, element.color, 1.0)
			#DebugElement.draw_type.CIRCLE:
				#var point_count = 16
				#draw_arc(element.body.global_position, element.pos.length(), 0.0, TAU, point_count, element.color, 1.0)
	#if point != null:
		#draw_circle(Vector2(5,5), 5, Color.WHITE)
	#for point in points:
		#draw_circle(point, 5, Color.WHITE)

func _process(delta: float) -> void:
	queue_redraw()
	
func draw_point(body, pos, color = default_color):
	var element = DebugElement.new()
	element.type = DebugElement.draw_type.POINT
	element.body = body
	element.pos = pos
	element.color = color
	add_element_to_queue(element)
	
func add_element_to_queue(element):
	var element_exists = false
	for queued_element in queue:
		if queued_element.type == element.type and queued_element.body == element.body and queued_element.pos.is_equal_approx(element.pos):
			element_exists = true
			print("Element already queued")
	if !element_exists:
		queue.append(element)
	
	
#func draw_point(pos):
	#point = pos
	#
#func add_point(pos):
	#points.append(pos)
	#
#func clear_points():
	#points = []
	
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
