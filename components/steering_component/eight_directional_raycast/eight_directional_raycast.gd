extends Behavior

@export var steering_component : SteeringComponent
@export var color : Color
@export var target_layer : int

@export var radius = 30

@export var avoidance_weight_gain = 5

var raycasts = []
#var lines = []

var target = null

func _ready() -> void:
	for direction in directions:
		var r = RayCast2D.new()
		r.target_position = direction.normalized() * radius
		r.self_modulate = 0
		for layer in range(16):
			layer += 1
			if layer != target_layer:
				r.set_collision_mask_value(layer, false)
			else:
				r.set_collision_mask_value(layer, true)
		add_child(r)
		raycasts.append(r)
		
		#var l = Line2D.new()
		#l.width = 1
		#l.default_color = color
		#l.add_point(Vector2.ZERO)
		#l.add_point(direction.normalized() * 50)
		#r.add_child(l)
		
		
		#lines.append(l)

func update():
	find_target()
	calculate_directional_weights()
	
func find_target():
	var targets = []
	for raycast in raycasts:
		var collider = raycast.get_collider()
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
	weights = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	if target:
		var target_direction = self.global_position.direction_to(target.global_position)
		if target_direction:
			for i in range(directions.size()):
				var raycast = raycasts[i]
				if raycast.is_colliding():
					var collision_distance = (global_position - raycast.get_collision_point()).length()
					var weight = (radius - collision_distance) / radius
					weight *= avoidance_weight_gain
					weights[i] -= weight
					#weights[i - 1] -= weight * 0.05
					#if i + 1 == weights.size():
						#weights[0] -= weight * 0.05
					#elif i + 1 > weights.size():
						#push_error('Directions and weights arrays out of sync')
					#else:
						#weights[i + 1] -= weight * 0.33					
					if weights[i] > 1.0:
						push_warning('Issue with weight calculation in eight_directional_raycast')
			
				#lines[i].set_point_position(1, directions[i].normalized() * weights[i] * 100) # TODO: Make variable for weighted_line length
				#if weights[i] < 0:
					#lines[i].set_point_position(1, directions[i].normalized() * weights[i] * 100) # TODO: Make variable for weighted_line length
				#else:
					#lines[i].set_point_position(1, Vector2.ZERO)
			#print(weights)
	#else:
		#for direction in range(directions.size()):
			#lines[direction].set_point_position(1, Vector2.ZERO)
			#weights = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
		
