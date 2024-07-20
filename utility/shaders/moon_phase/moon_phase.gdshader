shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.); 
uniform vec4 shaded_color: source_color = vec4(0., 0., 0., 1.);
uniform float speed : hint_range(0.0, 2.0, 0.01);
uniform float dist : hint_range(0., 240., .01);
uniform sampler2D noise_texture : source_color;
uniform float roughness : hint_range(0., 4., .01);

void fragment() {
  vec2 uv = 2.*(UV - vec2(.5));
  float height = (texture(noise_texture, UV).r-.5)*roughness;
	
  vec3 sphere_point = vec3(uv.x+height, uv.y, 1.-sqrt(uv.x*uv.x + uv.y*uv.y));
  vec3 light_point = dist*vec3(sin(PI*-TIME*.25*speed), uv.y/dist, cos(-TIME*.25*speed*PI));
  float dot_val = dot(sphere_point, (light_point-sphere_point)/length(light_point-sphere_point));
  float val  = smoothstep(-.05, 0., dot_val);
	
  COLOR = mix(color, shaded_color, val);
  COLOR.a *= smoothstep(1., .98, length(uv));
}