shader_type canvas_item;


void fragment()
{   
	vec2 frCoor = UV * vec2(textureSize(TEXTURE, 0)) * 2.0;
	ivec2 texPos = ivec2(frCoor.xy / 2.);
	int id = int(floor(mod(frCoor.x, 2.)) + floor(mod(frCoor.y, 2.)) * 2.); // 0-1 / 2-3

	vec4 B = texelFetch(TEXTURE, texPos + ivec2(0,-1), 0);
	vec4 D = texelFetch(TEXTURE, texPos + ivec2(-1,0), 0);
	vec4 C = texelFetch(TEXTURE, texPos, 0);
	vec4 F = texelFetch(TEXTURE, texPos + ivec2(1,0), 0);
	vec4 H = texelFetch(TEXTURE, texPos + ivec2(0,1), 0);

	vec4 result;

	if( (B != H) && (D != F) ) {
		if (id == 0) {
			result = (D == B) ? D : C;
		} else if (id == 1) {
			result = (B == F) ? F : C;
		} else if (id == 2) {
			result = (D == H) ? D : C;
		} else {
			result = (H == F) ? F : C;
		}
	} 
	else {
		result = C;
	}
	
	COLOR = result;
}