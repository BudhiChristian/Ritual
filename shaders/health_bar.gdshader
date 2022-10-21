shader_type canvas_item;

uniform float health = 1.0; 

void fragment() {
	vec4 baseTexture = texture(TEXTURE, UV);
	float alpha = baseTexture.a;
	if (UV.y < 1.0 - health) {
		alpha = 0.0;
	}
	COLOR.a = alpha;
}
