extends Behavior

@export var steering_component : SteeringComponent
@export var color : Color
@export var target_layer : int
@export var direction_radius = 150

@export var radius = 50
@export var agent_collider_size = 20

var raycasts = []
var lines = []

var targets = []
var target = null

func _ready() -> void:
	for direction in directions:
		var r = RayCast2D.new()
		r.target_position = direction.normalized() * direction_radius
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
		l.add_point(direction.normalized() * 50)
		r.add_child(l)
		
		raycasts.append(r)
		lines.append(l)

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
				var distance_to_object
				#var dot_product = target_direction.dot(direction.normalized())
				var collider = raycast.get_collider()
				if collider:
					distance_to_object = (global_position - raycast.get_collision_point()).length()
					#print(distance_to_object)
					if distance_to_object < agent_collider_size:
						weights[i] += -1.0
						weights[i - 1] += -0.33
						if i + 1 >= directions.size():
							weights[-1] += -0.33
						else:
							weights[i + 1] += 0.33
					elif distance_to_object > radius:
						weights[i] = 0.0
					else:
						weights[i] += -(radius - distance_to_object) / radius
					#print(weights[direction])
					if weights[i] > 1.0:
						push_warning('Issue with weight calculation in eight_directional_raycast')
				else:
					weights[i] = 0.0
					
				
			var avoidance_weight_gain = 5
			for i in range(weights.size()):
				weights[i] *= avoidance_weight_gain
				lines[i].set_point_position(1, directions[i].normalized() * weights[i] * 100) # TODO: Make variable for weighted_line length
				#if weights[i] < 0:
					#lines[i].set_point_position(1, directions[i].normalized() * weights[i] * 100) # TODO: Make variable for weighted_line length
				#else:
					#lines[i].set_point_position(1, Vector2.ZERO)
	else:
		for direction in range(directions.size()):
			lines[direction].set_point_position(1, Vector2.ZERO)
			weights = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
		
