class_name Behavior extends Node2D

### Make sure that the proper mask layer is selected in the associated Area2D.


var direction
@export_range(0.0, 1.0) var steer_power: float = 1.0
#signal override_behaviors
	
#var eight_directions = {
		#"up": Vector2(0,1),
		#"up_right": Vector2(1,1),
		#"right": Vector2(1,0),
		#"down_right": Vector2(1,-1),
		#"down": Vector2(0,-1),
		#"down_left": Vector2(-1,-1),
		#"left": Vector2(-1,0),
		#"up_left": Vector2(-1,1)
	#}
