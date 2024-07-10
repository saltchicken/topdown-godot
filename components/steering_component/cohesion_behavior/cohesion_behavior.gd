extends Behavior

@export var cohesion_coefficient : float = .1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update():
	cohesion_rule()

func cohesion_rule() -> void:
	var perceived_centre:Vector2
	
	var boids = get_overlapping_bodies()
	for body in boids:
		if body is RedSlime:
			perceived_centre = perceived_centre + body.global_position
			
	perceived_centre = perceived_centre / (boids.size())
	
	#Debug.draw_point((perceived_centre))
	
	#direction = (perceived_centre-position) / 10
	direction = self.global_position.direction_to(perceived_centre) * cohesion_coefficient
