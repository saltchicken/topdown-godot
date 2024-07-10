extends Behavior

@onready var steering_component : SteeringComponent = get_parent()

@onready var player = check_for_player()
@onready var raycast = get_node("RayCast2D")
@onready var target_los = false
@onready var target_position = null
@onready var target_distance = null
@onready var reached_target = false

@onready var arrival_radius = 20 # TODO: Programmatically set to owners collision radius

func update():
	player = check_for_player()
	if player and !reached_target:
		raycast_handler()
	else:
		target_los = false
		direction = Vector2.ZERO
	if target_position != null:
		Debug.point('target position', owner, target_position)
	reached_target_position()
	
func check_for_player():
	for body in self.get_overlapping_bodies():
		if body is Player:
			return body
	return null
	
func raycast_handler():
	raycast.target_position = player.global_position - global_position
	var collider = raycast.get_collider()
	if collider is Player:
		#if !target_los:
			#override_behaviors.emit(false)
		target_los = true
		target_position = collider.global_position
		direction = global_position.direction_to(target_position)
		#Debug.line("LOS_Raycast direction", self, direction * 50)
	else:
		target_los = false
		direction = Vector2.ZERO
			
func reached_target_position():
	if target_position != null:
		target_distance = global_position.distance_to(target_position)
	else:
		target_position = null
		target_distance = null
		direction = Vector2.ZERO
		return
		
	if target_distance <= arrival_radius:
		target_position = null
		target_distance = null
		reached_target = true
		direction = Vector2.ZERO
	else:
		reached_target = false
		#print('idle emitted')
		#owner.idle.emit()
		#override_behaviors.emit(true)
