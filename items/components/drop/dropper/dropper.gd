extends CharacterBody2D

@onready var item_to_drop

@onready var timer = get_node("Timer")

func _ready():
	timer.timeout.connect(_on_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if item_to_drop == null:
		push_error("Dropper does not have an item")
		return
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
	velocity -= velocity * delta * 2

func _on_timeout():
	print(item_to_drop)
	remove_child(item_to_drop)
	item_to_drop.global_position = global_position
	item_to_drop.process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().current_scene.get_node("LevelHolder").get_children()[0].add_child(item_to_drop)
	queue_free()
