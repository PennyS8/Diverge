shader_type canvas_item;

uniform vec3 outline_color: source_color;
uniform float progress: hint_range(0.0, 1.0);

void fragment() {
	vec4 line_negative = vec4(outline_color.rgb, texture(TEXTURE, UV - 0.002).a);
	vec4 line_positive = vec4(outline_color.rgb, texture(TEXTURE, UV + 0.002).a);
	vec4 outline = mix(line_negative, line_positive, line_positive);
	COLOR.rgba = mix(COLOR, outline, progress * (1.0 - COLOR.a));
}