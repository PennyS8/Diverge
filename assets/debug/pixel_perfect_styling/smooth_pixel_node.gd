@tool
# Having a class name is required for a custom node.
class_name VisualShaderNodeSmoothPixelNode
extends VisualShaderNodeCustom


func _get_name():
	return "SmoothPixel"


func _get_category():
	return ""


func _get_description():
	return ""


func _get_return_icon_type():
	return PORT_TYPE_SCALAR


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	match port:
		0:
			return "uv"
		1:
			return "texture_pixel_size"
		2:
			return "texture"


func _get_input_port_type(port):
	match port:
		0:
			return PORT_TYPE_VECTOR_2D
		1:
			return PORT_TYPE_VECTOR_2D
		2:
			return PORT_TYPE_SAMPLER


func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	match port:
		0:
			return "color"

func _get_output_port_type(port):
	match port:
		0:
			return PORT_TYPE_VECTOR_4D

func _get_global_code(_mode):
	return """
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
	"""

func _get_code(input_vars, output_vars,
		_mode, _type):
	var code = \
		"""
		vec4 smoothed_texture = smoothpixel(%s, %s, %s);
		%s = smoothed_texture;
		""" % [input_vars[0], input_vars[1], input_vars[2], output_vars[0]]
	return code
