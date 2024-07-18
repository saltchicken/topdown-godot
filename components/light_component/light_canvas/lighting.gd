extends ColorRect

@onready var gametime = get_node('/root/Gameplay/Gametime')

func _ready() -> void:
	show()
	#test()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var lights_dict = get_lights()
	#var light_positions = get_light_positions()
	#print(light_positions)
	#print(lights_dict["positions"])
	material.set_shader_parameter("number_of_lights", lights_dict["positions"].size())
	material.set_shader_parameter("lights", lights_dict["positions"])
	material.set_shader_parameter("light_radiuses", lights_dict["radiuses"])
	var seconds = gametime.time_elapsed + (gametime.current_hour - 1) * 3600
	#var scaled_seconds = seconds / 86400.0
	var scaled_seconds = seconds / 43200.0
	var limited_seconds = scaled_seconds
	var tod_seconds
	if limited_seconds < 1.0:
		tod_seconds = 1.0 - limited_seconds
	else:
		tod_seconds = limited_seconds - 1.0
	material.set_shader_parameter("seconds", tod_seconds)
	#print(tod_seconds)

#func get_light_positions():
	#return get_tree().get_nodes_in_group("light").map(
		#func(light: Node2D):
			#return light.get_global_transform_with_canvas().origin
	#)
	
func get_lights():
	var lights_dict = {"positions": [], "radiuses": []}
	var lights = get_tree().get_nodes_in_group("light")
	for light in lights:
		var light_component = light.get_node_or_null("LightComponent")
		if light_component != null:
			lights_dict["positions"].append(light.get_global_transform_with_canvas().origin)
			lights_dict["radiuses"].append(light_component.radius)
		else:
			push_error("%s does not have a LightComponent" % light.name)
	return lights_dict
			
	
#func test():
	#prints("Owner", owner)
	#for child in owner.get_node('Bonfires').get_children():
		#print(child)
