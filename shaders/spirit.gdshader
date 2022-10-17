shader_type canvas_item;

uniform sampler2D smoke : repeat_enable;
uniform sampler2D opacity;

void fragment() {
	vec4 smokeTexture = texture(smoke, UV + vec2(sin(TIME) * 0.000025, -0.05));
	vec4 smokeTexture2 = texture(smoke, SCREEN_UV + vec2(0, -0.1) * TIME);
	
	float overlapStrength = ((smokeTexture.r * smokeTexture2.r) - 0.3) * 2.0 * UV.y;
	
	
	vec4 baseTexture = texture(TEXTURE, UV + vec2(0.25 * overlapStrength, 0));
	float opacityModifier = 1.0 - texture(opacity, UV).r * (smokeTexture.r * 0.75);
	
	float r = baseTexture.r * COLOR.r;
	float g = baseTexture.g * COLOR.g;
	float b = baseTexture.b * COLOR.b;
	float a = baseTexture.a * COLOR.a * opacityModifier;
	COLOR = vec4(r, g, b, a);
}
