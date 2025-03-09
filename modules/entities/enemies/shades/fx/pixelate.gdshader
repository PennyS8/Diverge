shader_type canvas_item;

uniform int x_pixel_size : hint_range(1, 100);
uniform int y_pixel_size : hint_range(1, 100);

void fragment() {
	vec2 correction = TEXTURE_PIXEL_SIZE * vec2(float(x_pixel_size), float(y_pixel_size)) / vec2(2.0);
	vec2 texture_uv = floor(UV / TEXTURE_PIXEL_SIZE);
	vec2 offset = vec2(float(int(texture_uv.x) % x_pixel_size), float(int(texture_uv.y) % y_pixel_size));
	vec2 target = (texture_uv - offset) * TEXTURE_PIXEL_SIZE;
	COLOR = texture(TEXTURE, target + correction );
}