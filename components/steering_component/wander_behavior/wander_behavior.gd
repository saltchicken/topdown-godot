extends Behavior

@export var directional_bias: int = 150
@export var directional_radius: int = 100
var NUM_POINTS = 16

@onready var steering = get_parent()

var rng = RandomNumberGenerator.new()

func update():
	wander_rule()
	
func calc_point(random_point):
	return Vector2(0, directional_radius).rotated((random_point / float(NUM_POINTS)) * TAU) + global_position + steering.previous_direction * directional_bias
	
func wander_rule():
	var random_point = rng.randi_range(0, NUM_POINTS - 1)
	var random_point_position = calc_point(random_point)
	direction = global_position.direction_to(random_point_position)
	Debug.line('direction', self, direction * 50)
	Debug.point('random_points', self, random_point_position)
	
	#Debug.circle('wander circle', self, Vector2(SIZE, 0))
	#Debug.point('wander circle point', self, path.curve.get_point_position(0) + global_position)
