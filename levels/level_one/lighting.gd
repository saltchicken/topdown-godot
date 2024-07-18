extends ColorRect

@onready var gametime = get_node('/root/Gameplay/Gametime')

func _ready() -> void:
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var light_positions = get_light_positions()
	material.set_shader_parameter("number_of_lights", light_positions.size())
	material.set_shader_parameter("lights", light_positions)
	var seconds = gametime.time_elapsed + (gametime.current_hour - 1) * 3600
	var scaled_seconds = seconds / 86400.0
	var limited_seconds = scaled_seconds - 0.5
	var tod_seconds
	if limited_seconds < 0.0:
		tod_seconds = abs(limited_seconds * 2)
	else:
		tod_seconds = limited_seconds * 2
	material.set_shader_parameter("seconds", tod_seconds)
	#print(tod_seconds)

func get_light_positions():
	return get_tree().get_nodes_in_group("light").map(
		func(light: Node2D):
			return light.get_global_transform_with_canvas().origin
	)
