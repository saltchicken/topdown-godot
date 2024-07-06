class_name Enemy extends CharacterBody2D

@export var initial_state : State

@onready var collision

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	collision = move_and_collide(velocity * delta)
