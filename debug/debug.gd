extends Node2D

@onready var points = []
@onready var point = null


func _draw():
	if point != null:
		draw_circle(point, 5, Color.WHITE)
	for point in points:
		draw_circle(point, 5, Color.WHITE)
	
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	queue_redraw()
	
func draw_point(pos):
	point = pos
	
func add_point(pos):
	points.append(pos)
	
func clear_points():
	points = []
	
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
