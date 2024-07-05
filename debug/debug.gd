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
