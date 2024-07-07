class_name DebugElement extends Node2D

enum draw_type {
	POINT,
	LINE,
	CIRCLE
}
var type
var id
var body
var pos: Vector2
var color: Color

#func draw():
	#match type:
		#draw_type.POINT:
			#print(pos)
			#print(color)
			#draw_circle(pos, 5, color)
		#draw_type.LINE:
			#draw_line(body.global_position, pos, color, 1.0)
		#draw_type.CIRCLE:
			#var point_count = 16
			#draw_arc(body.global_position, pos.length(), 0.0, TAU, point_count, color, 1.0)
	
