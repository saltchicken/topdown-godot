class_name Player extends CharacterBody2D

@export var initial_state: State

@export var run_speed: float = 300

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta) # TODO: Maybe move this to the state_machine's update
	
