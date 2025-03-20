shader_type canvas_item;

uniform float amount = 0.0;

void fragment() {
	float newAmount = (amount / 100.0) + 1.0;
	
	vec2 texcoord0 = UV;
	vec2 kCenter = vec2(0.5);
	
	vec2 vec = (texcoord0 - kCenter) / kCenter;
	float vecLength = length(vec);
	float r = pow(min(vecLength, 1.0), newAmount) * max(1.0, vecLength);
	vec2 unit = vec / vecLength;

	texcoord0 = kCenter + r * unit * kCenter;
	
	COLOR = texture(TEXTURE, texcoord0);
}
