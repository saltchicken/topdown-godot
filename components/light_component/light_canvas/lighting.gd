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
	var scaled_seconds = seconds / 43200.0
	var tod_seconds
	if scaled_seconds < 1.0:
		tod_seconds = 1.0 - scaled_seconds
	else:
		tod_seconds = scaled_seconds - 1.0
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
		var light_state = light.get_node_or_null("StateMachine")
		if !light_state:
			push_error("%s did not have statemachine" % light.name)
			continue
		else:
			if light_state.current_state.name != "on": # TODO: Handle checking if light object is on better. Also the Player reference is dirty.
				if light is not Player:
					continue
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
