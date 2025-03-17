// 2D Pixel Art Highlight Shader
// Creates a crisp pixel line of a given size that periodically glides over the sprite.
//
// You must supply the texture_size uniform with the size of the texture in the sprite.
// Use a negative size_effect for flipping the direction.
shader_type canvas_item;

uniform sampler2D vertical_gradient; // Used to set alpha values
uniform sampler2D color_gradient; // Sets the effect color
uniform float size_effect: hint_range(1.0, 10.0, 1.0) = 1.0; // Size of the effect in pixel units
uniform float speed = 1; // Effect speed
uniform float highlight_strength: hint_range(-4.0, 4.0, 0.05) = 0.5; // Strength of the highlight
uniform bool color_mode_toggle = false; // Toggle for color gradient application
uniform bool is_horizontal = false; // Switches effect direction
uniform float pause_duration = 0.5; // Pause duration between cycles
uniform vec2 texture_size = vec2(16, 16); // Texture size in pixels (e.g., vec2(16.0, 16.0) for a 16x16 texture)

render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);

	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}

	COLOR *= c;

    // Set up base parameters
    vec4 old_color = COLOR;
    float time = TIME * abs(speed); // Absolute time for both positive and negative speeds
    float effect_cycle_duration = 1.0 + pause_duration; // Total time for one cycle and pause
    float mod_time = mod(time, effect_cycle_duration); // Current time within the cycle

    // Handle the pause
    float progress = mod_time / 1.0; // Normalize mod_time for active duration only

    if (mod_time > 1.0) {
        progress = 1.0; // Hold the highlight at the last position during the pause
    }

    // Reverse the direction if speed is negative
    if (speed < 0.0) {
        progress = 1.0 - progress; // Reverse progress when speed is negative
    }

    // Convert the size_effect from pixels to UV space based on the texture size
    float pixel_to_uv = size_effect / ((is_horizontal) ? texture_size.x : texture_size.y);

    // Calculate the current position of the highlight in UV space
    float current_position = mix(0.0, 1.0, progress);

    // Set the lower and upper bounds for the highlight effect
    float effect_lower_bound = current_position - (pixel_to_uv / 2.0);
    float effect_upper_bound = current_position + (pixel_to_uv / 2.0);

    // Snap the UV coordinates to the pixel grid
    vec2 pixel_size_uv = vec2(1.0) / texture_size;
    vec2 snapped_uv = floor(UV / pixel_size_uv) * pixel_size_uv;

    // Get the position of the pixel in the effect (either horizontal or vertical)
    float position_value = (is_horizontal) ? snapped_uv.x : snapped_uv.y;

    // Use step to create crisp boundaries for the effect
    float effect_distance = step(effect_lower_bound, position_value) - step(effect_upper_bound, position_value);

    // Get the position of the pixel within the inner gradient
    float inner_effect_position = step(effect_lower_bound, position_value) * step(position_value, effect_upper_bound);
    vec2 color_position = (color_mode_toggle) ? vec2(UV.x, inner_effect_position) : vec2(progress);

    // Sample the new color from the color gradient
    vec4 new_color = texture(color_gradient, color_position);

    // Sample the vertical gradient and mix it with the new color
    new_color = mix(old_color, new_color, texture(vertical_gradient, vec2(progress)));

    // Apply the highlight effect using the calculated effect_distance
    COLOR.rgb = mix(old_color.rgb, new_color.rgb, vec3(effect_distance * highlight_strength));
}
