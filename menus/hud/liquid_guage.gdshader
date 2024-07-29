shader_type canvas_item;

// fV = fill value
uniform float fillValue;
uniform vec4 color_subtract : source_color = vec4(0.0);

void fragment() {
    vec2 uv = ((UV / -0.5)) + vec2(1.0, 1.0);

    float sdf = length(uv);
    float c = step(sdf, .85);
        
    float vB = smoothstep(.1, .9, sin(uv.x + (PI * .5)) - .3);
    float vBA = vB * sin(TIME * 4.) * .1;
        
    float fW = (sin(((TIME * 2.) + uv.x) * 2.) * .05) + vBA;
    float bW = (sin(((TIME * -2.) + uv.x) * 2. + PI) * .05) - vBA;
        
    float fA = (sin(TIME * 4.) * .05) * vB;
        
    float fP = fillValue * 2.3 + (sin((TIME) * PI) * .1) - 1.1;
        
    float fF = step(uv.y, (fA + fW) + fP) * c;
    float bF = step(uv.y, (-fA + bW) + fP) * c;

    COLOR = vec4(fF + (clamp(bF - fF, 0., 1.) * .8)) - color_subtract;
}
