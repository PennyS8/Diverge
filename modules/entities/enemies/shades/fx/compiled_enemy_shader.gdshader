shader_type canvas_item;
render_mode blend_mix;


// Varyings
varying vec4 var_modulate;

uniform bool Flash = false;
uniform vec4 ColorParameter : source_color = vec4(1.000000, 1.000000, 1.000000, 1.000000);


// SmoothPixel

		vec4 smoothpixel(vec2 uv_in, vec2 texture_pixel_size, sampler2D original_texture) {
			vec2 box_size = clamp(fwidth(uv_in) / texture_pixel_size, 1e-5, 1);
			// Scale UV by texture size to get texel coordinate
			vec2 tx = uv_in / texture_pixel_size - 0.5 * box_size;
			// Compute offset for pixel-sized box filter
			vec2 tx_offset = smoothstep(vec2(1) - box_size, vec2(1), fract(tx));
			// Compute bilinear sample UV coordinates
			vec2 uv = (floor(tx) + 0.5 + tx_offset) * texture_pixel_size;
			// sample the texture
			return texture(original_texture, uv);
		}
	

void vertex() {
// Input:3
	vec4 n_out3p0 = COLOR;


// VaryingSetter:2
	var_modulate = n_out3p0;


}

void fragment() {
// BooleanParameter:17
	bool n_out17p0 = Flash;


// ColorParameter:19
	vec4 n_out19p0 = ColorParameter;


// VaryingGetter:12
	vec4 n_out12p0 = var_modulate;


// Input:5
	vec2 n_out5p0 = UV;


// Input:4
	vec2 n_out4p0 = TEXTURE_PIXEL_SIZE;


	vec4 n_out9p0;
// SmoothPixel:9
	{
		
				vec4 smoothed_texture = smoothpixel(n_out5p0, n_out4p0, TEXTURE);
				n_out9p0 = smoothed_texture;
				
	}


// VectorOp:15
	vec4 n_out15p0 = n_out12p0 * n_out9p0;
	float n_out15p4 = n_out15p0.a;


	vec3 n_out20p0;
// Switch:20
	n_out20p0 = mix(vec3(n_out15p0.xyz), vec3(n_out19p0.xyz), float(n_out17p0));


// Output:0
	COLOR.rgb = n_out20p0;
	COLOR.a = n_out15p4;


}
