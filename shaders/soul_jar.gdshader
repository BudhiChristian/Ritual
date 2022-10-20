shader_type canvas_item;

// Set by script
uniform float red = 1.0; 
uniform float green = 1.0; 
uniform float blue = 0.0; 

void fragment() {
	vec4 baseTexture = texture(TEXTURE, UV);
	// Jar contents color target is magenta RGB(1,0,1)
	if (baseTexture.r == 1.0 && baseTexture.b == 1.0) {
		COLOR = vec4(red, green, blue, baseTexture.a);
	} else {
		COLOR = baseTexture;
	}
}
