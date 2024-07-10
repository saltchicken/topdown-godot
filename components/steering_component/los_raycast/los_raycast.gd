extends Behavior

@onready var steering_component : SteeringComponent = get_parent()
@onready var raycast = get_node("RayCast2D")
var target_position = null
@onready var arrival_radius = 20 # TODO: Programmatically set to owners collision radius

func init():
	target_position = null

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
		check_if_reached_target_position()
	else:
		direction = Vector2.ZERO
	
func check_for_player():
	for body in self.get_overlapping_bodies():
		if body is Player:
			return body
	return null
	
func check_if_reached_target_position():
	var target_distance = global_position.distance_to(target_position)
	if target_distance <= arrival_radius:
		print('reached')
		target_position = null
		direction = Vector2.ZERO
