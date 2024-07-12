extends Area2D
@export var input: InputComponent
@export var reach: float = 15.0

@onready var collision_shape = get_node("CollisionShape2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if input.direction:
		collision_shape.position = input.direction * reach
	else:
		collision_shape.position = input.previous_direction * reach

func interact():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		var interactable_component = body.get_node_or_null("InteractableComponent")
		if interactable_component:
			interactable_component.interact()
