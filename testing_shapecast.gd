extends ShapeCast2D

@export var steering : SteeringComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.target_position = steering.direction_to_player * 50
	#print(self.collision_result)
