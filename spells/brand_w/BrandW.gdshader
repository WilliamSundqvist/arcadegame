shader_type canvas_item;

uniform vec2 center;
uniform float force;

void fragment() {
	vec2 disp = normalize(UV - center) * force;
	COLOR = vec4(UV - disp, 0.0, 1.0);
	COLOR = texture(TEXTURE, UV - disp);
	//COLOR = vec4(UV, 0.0, 1);
	// Called for every pixel the material is visible on.
}