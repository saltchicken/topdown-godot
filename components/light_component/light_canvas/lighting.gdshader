shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec2 lights[100];
uniform vec2 light_radiuses[100];
uniform int number_of_lights = 1;
uniform vec4 modulate_color : source_color = vec4(0.0);
uniform float light_radius = 192.0;
uniform float band_radius = 128.0;
uniform float band_strength = 0.3;

uniform float seconds = 0.0;

float distance_to_light(vec2 coords) {
	float dist = 10000.0;
	
	for (int i = 0; i < number_of_lights; i++) {
		float new_dist = distance(coords, lights[i]);	
		if (new_dist < dist) {
			dist = new_dist;
		}
	}
	return dist;
}

vec4 modulate(vec4 color, float distance_to_light) {
	vec4 tod = vec4(modulate_color.xyz, seconds);
	vec4 modulated = color * tod;
	
	if (distance_to_light > light_radius) {
		return modulated;
	}
	
	//if(distance_to_light >= band_radius) {
		//return mix(modulated, color, band_strength);
	//}
	
	return color;
}

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	COLOR = modulate(COLOR, distance_to_light(FRAGCOORD.xy));
}



//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
