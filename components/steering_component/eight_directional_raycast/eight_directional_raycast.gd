extends Behavior

@export var avoidance_coefficient: float = 10
@export var color : Color
@export var target_layer : int

@export var look_ahead = 30

var weights = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

var directions = [
		Vector2(0,1),
		Vector2(1,1),
		Vector2(1,0),
		Vector2(1,-1),
		Vector2(0,-1),
		Vector2(-1,-1),
		Vector2(-1,0),
		Vector2(-1,1)
	]

var raycasts = []
#var lines = []

var target = null

func _ready() -> void:
	for d in directions:
		var r = RayCast2D.new()
		r.target_position = d.normalized() * look_ahead
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
		#l.add_point(d.normalized() * 50)
		#r.add_child(l)
		
		
		#lines.append(l)

func update():
	find_target()
	calculate_directional_weights()
	calculate_velocity()
	
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
					var weight = (look_ahead - collision_distance) / look_ahead
					weights[i] -= weight
					if weight > 0.6:
						weights[i - 1] -= weight * 0.15
						weights[(i + 1) % weights.size()] -= weight * 0.15		
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
			
func calculate_velocity():
	direction = Vector2.ZERO
	for i in range(directions.size()):
		direction += weights[i] * directions[i]
	#direction = direction.normalized()
	direction *= avoidance_coefficient
	#Debug.line("Eight_Directional direction", self, direction * 50)
	
