extends CharacterBody2D

@export var initial_state : State

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)
