@tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeDeepParallax

func _get_name():
	return "DeepParallax"

func _get_category():
	return "3D"

func _get_subcategory():
	return "Depth"

func _get_description():
	return "Deep Parallax"

func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_SCALAR

func _get_input_port_count():
	return 5

func _get_input_port_name(port):
	match port:
		0:
			return "uv"
		1:
			return "texture"
		2:
			return "depth_scale"
		3:
			return "base layers"
		4:
			return "detail layers"
		# 5:
		# 	return "(vertex)"
		# 6:
		# 	return "(normal)"
		# 7:
		# 	return "(tangent)"
		# 8:
		# 	return "(binormal)"
		# 9:
		# 	return "(depth_flip)"

func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_SAMPLER
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR
		3:
			return VisualShaderNode.PORT_TYPE_SCALAR
		4:
			return VisualShaderNode.PORT_TYPE_SCALAR
		# 5:
		# 	return VisualShaderNode.PORT_TYPE_VECTOR_3D
		# 6:
		# 	return VisualShaderNode.PORT_TYPE_VECTOR_3D
		# 7:
		# 	return VisualShaderNode.PORT_TYPE_VECTOR_3D
		# 8:
		# 	return VisualShaderNode.PORT_TYPE_VECTOR_3D
		# 9:
		# 	return VisualShaderNode.PORT_TYPE_VECTOR_3D

func _get_output_port_count():
	return 1

func _get_output_port_name(port):
	match port:
		0:
			return "uv"

func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D

func _get_global_code(mode):
	if mode != Shader.MODE_SPATIAL:
		return ""
		
	var code = preload("deep_parallax.gdshader").code
	code = code.replace("shader_type spatial;\n", "")
	return code

func _get_code(input_vars, output_vars, mode, type):
	if mode != Shader.MODE_SPATIAL or type != VisualShader.TYPE_FRAGMENT:
		return ""
	
	# Default values
	var uv = "UV"
	var texture = "texture_parallax_default"
#	var depth_scale = "0.05"
	var depth_scale = "depth_scalar"
	var base_layers = "128.0"
	var detail_layers = "64.0"
	var vertex = "VERTEX"
	var normal = "NORMAL"
	var tangent = "TANGENT"
	var binormal = "BINORMAL"
	var depth_flip = "vec3(1.0, 1.0, 0.0)"

	if input_vars[0]:
		uv = input_vars[0]
	if input_vars[1]:
		texture = input_vars[1]
	if input_vars[2]:
		depth_scale = input_vars[2]	
	if input_vars[3]:
		base_layers = input_vars[3]
	if input_vars[4]:
		detail_layers = input_vars[4]	
	# if input_vars[5]:
	# 	vertex = input_vars[5]
	# if input_vars[6]:
	# 	normal = input_vars[6]
	# if input_vars[7]:
	# 	tangent = input_vars[7]
	# if input_vars[8]:
	# 	binormal = input_vars[8]
	# if input_vars[9]:
	# 	depth_flip = input_vars[9]

	var params =  [uv, texture, depth_scale, base_layers, detail_layers, vertex, normal, tangent, binormal, depth_flip, output_vars[0]]
	return "deep_parallax(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);" % params

func _init(): 
	# Default values for the editor
	# depth_scalefloatcon
#	if not get_input_port_default_value(2):
#		set_input_port_default_value(2, 0.05)
	# min_layers
	if not get_input_port_default_value(3):
		set_input_port_default_value(3, 128.0)
	# max_layers
	if not get_input_port_default_value(4):
		set_input_port_default_value(4, 64.0)
	# depth_flip
#	if not get_input_port_default_value(9):
	set_input_port_default_value(9, Vector3(1.0, 1.0, 0.0))
