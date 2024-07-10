extends Behavior

@onready var steering_component : SteeringComponent = get_parent()

#@onready var player = check_for_player()
@onready var raycast = get_node("RayCast2D")
var target_position = null
#var previous_target_position = null
#@onready var target_los = false
#@onready var target_position = null
#@onready var target_distance = null
#@onready var reached_target = false

@onready var arrival_radius = 20 # TODO: Programmatically set to owners collision radius

#func update():
	#var player = check_for_player()
	#if player:
		#raycast.target_position = player.global_position - global_position
		#var collider = raycast.get_collider()
		#if collider is Player:
			#target_position = collider.global_position # or player.global_position
		#else:
			#target_position = previous_target_position
	#previous_target_position = target_position
	#if target_position != null:
		#direction = global_position.direction_to(target_position)
		#Debug.point('target position', owner, target_position)
	#else:
		#direction = Vector2.ZERO
		#
	#print(direction)
	
func update():
	var player = check_for_player()
	if player:
		raycast.target_position = player.global_position - global_position
		var collider = raycast.get_collider()
		if collider is Player:
			target_position = collider.global_position # or player.global_position
	if target_position != null:
		direction = global_position.direction_to(target_position)
		Debug.point('target position', owner, target_position)
		var target_distance = global_position.distance_to(target_position)
		if target_distance <= arrival_radius:
			print('reached')
			target_position = null
			direction = Vector2.ZERO
	else:
		direction = Vector2.ZERO
	
	
	
	#else:
		#target_los = false
		#direction = Vector2.ZERO
	#if target_position != null:
		#Debug.point('target position', owner, target_position)
	#reached_target_position()
	
func check_for_player():
	for body in self.get_overlapping_bodies():
		if body is Player:
			return body
	return null

		
		##Debug.line("LOS_Raycast direction", self, direction * 50)
	#else:
		#target_los = false
		#direction = Vector2.ZERO
			#
#func reached_target_position():
	#if target_position != null:
		#target_distance = global_position.distance_to(target_position)
	#else:
		#target_position = null
		#target_distance = null
		#direction = Vector2.ZERO
		#return
		#
	#if target_distance <= arrival_radius:
		#target_position = null
		#target_distance = null
		#reached_target = true
		#direction = Vector2.ZERO
	#else:
		#reached_target = false
		##print('idle emitted')
		##owner.idle.emit()
		##override_behaviors.emit(true)
