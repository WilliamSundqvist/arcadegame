shader_type canvas_item;
uniform vec3 shock_color : source_color = vec3(1.0, 0.0, 0.0);
uniform float start = 1;

void fragment() {

    // Using start as the time progress (expecting it to go from 0.0 to 1.0)
    vec3 normal_color = texture(TEXTURE, UV).rgb;
    // Adjust the effect to complete within 1 second (start should range from 0 to 1)
   	COLOR.rgb = normal_color + shock_color * exp(-5.0 * start);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
