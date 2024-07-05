extends Node2D

@export var steering_component : SteeringComponent
@export var color : Color
@export var target_layer : int
@export var direction_radius = 150
@onready var eight_directions = {
		"up": Vector2(0,1),
		"up_right": Vector2(1,1),
		"right": Vector2(1,0),
		"down_right": Vector2(1,-1),
		"down": Vector2(0,-1),
		"down_left": Vector2(-1,-1),
		"left": Vector2(-1,0),
		"up_left": Vector2(-1,1)
	}
var raycasts = {}
var lines = {}
var weights = {}

var targets = []
var target = null

func _ready() -> void:
	for direction in eight_directions.keys():
		var r = RayCast2D.new()
		r.target_position = eight_directions[direction].normalized() * direction_radius
		r.self_modulate = 0
		for layer in range(16):
			layer += 1
			if layer != target_layer:
				r.set_collision_mask_value(layer, false)
			else:
				r.set_collision_mask_value(layer, true)
		add_child(r)
		
		var l = Line2D.new()
		l.width = 1
		l.default_color = color
		l.add_point(Vector2.ZERO)
		l.add_point(eight_directions[direction].normalized() * 50)
		r.add_child(l)
		
		raycasts[direction] = r
		lines[direction] = l

func _physics_process(delta: float) -> void: # TODO: Should this be called so often?
	calculate_directional_weights()
	find_target()
	#for raycast in raycasts.keys():
		#var collider = raycasts[raycast].get_collider()
		#if collider:
			#print(collider)
			#pass
			
func find_target():
	targets = []
	for raycast in raycasts.keys():
		var collider = raycasts[raycast].get_collider()
		if collider:
			targets.append(collider)
	if targets.size() == 0:
		target = null
	else:
		target = null
		var closest_distance = null
		for body in targets:
			if target == null:
				target = body
				closest_distance = self.global_position.distance_to(body.global_position)
			else:
				var distance = self.global_position.distance_to(body.global_position)
				if distance < closest_distance:
					target = body
					closest_distance = distance
					
				
	
			
func calculate_directional_weights():
	if target:
		var target_direction = self.global_position.direction_to(target.global_position)
		if target_direction:
			for direction in eight_directions.keys():
				var raycast = raycasts[direction]
				var dot_product = target_direction.dot(eight_directions[direction].normalized())
				weights[direction] = dot_product
				if dot_product > 0:
					lines[direction].set_point_position(1, eight_directions[direction].normalized() * dot_product * 100) # TODO: Make variable for weighted_line length
				else:
					lines[direction].set_point_position(1, Vector2.ZERO)
	else:
		for direction in eight_directions.keys():
			lines[direction].set_point_position(1, Vector2.ZERO)
		
