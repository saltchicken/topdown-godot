extends Behavior

@export var steering_component : SteeringComponent

@onready var raycast = get_node("RayCast2D")
@onready var target_los = false
@onready var target_position = null
@onready var target_distance = null

@onready var arrival_radius = 20 # TODO: Programmatically set to owners collision radius

func update():
	if steering_component.player:
		raycast_handler()
	else:
		target_los = false
	if target_position != null:
		Debug.point('target position', self, target_position)
		reached_target_position()
	
func raycast_handler():
	raycast.target_position = steering_component.player.global_position - global_position
	var collider = raycast.get_collider()
	if collider is Player:
		#if !target_los:
			#override_behaviors.emit(false)
		target_los = true
		target_position = collider.global_position
		direction = global_position.direction_to(target_position)
	else:
		target_los = false
			
func reached_target_position():
	target_distance = global_position.distance_to(target_position)
	if target_distance <= arrival_radius:
		target_position = null
		target_distance = null
		direction = Vector2.ZERO
		#override_behaviors.emit(true)
