extends Behavior

@export var alignment_coefficient : float = 1
@onready var boid_area = get_node("Area2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update():
	var perceived_velocity:Vector2
	
	var boids = boid_area.get_overlapping_bodies()
	for body in boids:
		if body is RedSlime:
			perceived_velocity = perceived_velocity + body.velocity
	
	perceived_velocity = perceived_velocity / boids.size()
	
	velocity = perceived_velocity.normalized() * alignment_coefficient
	#print(velocity)
