@tool
class_name VisualShaderNodeFlipbook
extends VisualShaderNodeCustom


#region Metadata

func _get_name() -> String:
	return "Flipbook"

func _get_category() -> String:
	return "Utility"

func _get_description() -> String:
	return "Flipbook"

func _get_return_icon_type() -> PortType:
	return PORT_TYPE_VECTOR_2D

#endregion


#region Input Ports

func _get_input_port_count() -> int:
	return 2

func _get_input_port_name(port: int) -> String:
	match port:
		0:
			return "uv in"
		1:
			return "speed"
	return ""

func _get_input_port_type(port: int) -> PortType:
	match port:
		0:
			return PORT_TYPE_VECTOR_2D
		1:
			return PORT_TYPE_SCALAR
	return PORT_TYPE_SCALAR

#endregion


#region Output Ports

func _get_output_port_count() -> int:
	return 2

func _get_output_port_name(port: int) -> String:
	match port:
		0:
			return "uv out"
		1:
			return "lerpframe data"
	return ""

func _get_output_port_type(port: int) -> PortType:
	match port:
		0:
			return PORT_TYPE_VECTOR_2D
		1:
			return PORT_TYPE_VECTOR_3D
	return PORT_TYPE_SCALAR

#endregion


#region Shader Code Generation

func _get_global_code(mode: Shader.Mode) -> String:
	var code = preload("flipbook.gdshader").code
	code = code.replace("shader_type spatial;\n", "")
	return code

func _get_code(input_vars: Array[String], output_vars: Array[String], mode: Shader.Mode, type: VisualShader.Type) -> String:
	# Fallback values when ports are unconnected
	var uv: String = "UV"
	var rate: String = "1.0"

	if input_vars[0]:
		uv = input_vars[0]
	if input_vars[1]:
		rate = input_vars[1]

	var params = [uv, rate, output_vars[0], output_vars[1]]
	return "fLiPBook(%s, %s, INSTANCE_CUSTOM, TIME, %s, %s);" % params

#endregion


#region Initialization

func _init():
	if not get_input_port_default_value(1): # speed
		set_input_port_default_value(1, 1.0)

#endregion