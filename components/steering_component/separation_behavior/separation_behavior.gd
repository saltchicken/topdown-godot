extends Behavior

@export var separation_coefficient : float = 0.5
@export var separation_amount : float = 100
@onready var boid_area = get_node("Area2D")

func update():
	separation_rule()
	
func separation_rule():
	var separation_vec:Vector2
	
	var boids = boid_area.get_overlapping_bodies()
	for body in boids:
		if body is RedSlime:
			if (body.global_position - global_position).length() < separation_amount:
				separation_vec = separation_vec - (body.global_position - global_position)
	
	#velocity = -self.global_position.direction_to(separation_vec) * separation_coefficient
	velocity = separation_vec.normalized() * separation_coefficient